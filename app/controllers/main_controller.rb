require "ostruct"
require "web_utils"
class MainController < ApplicationController

 respond_to :js, :html, :json, :csv#, :xls

 skip_before_filter :check_account_cur, :only => [:index]
  def index
   @news = NewsArticle.order("created_at desc").all
  end

  def search
   @only_store = params[:search].try(:[], :only_store) || false
   stor = Setting.by_user(current_user.id).by_name("search.only_store").first || Setting.by_user(current_user.id).by_name("search.only_store").new
   stor.value = @only_store
   stor.save!
   gon.only_store = WebUtils.to_bool(@only_store) #TODO: clean gon
   @only_available = params[:search].try(:[], :only_available) || false
   avail = Setting.by_user(current_user.id).by_name("search.only_available").first || Setting.by_user(current_user.id).by_name("search.only_available").new
   avail.value = @only_available
   avail.save!
   @items = Offer::Store.search(params[:search]).process{|i| i.sort{|a, b| a.name == b.name ? (a.brend == b.brend ? (a.body_name == b.body_name ? (a.rohs == b.rohs ? (a.location_id <=> b.location_id) : a.rohs <=> b.rohs) : a.body_name <=> b.body_name) : a.brend <=> b.brend) : a.name <=> b.name}}
   chk_err(@items)
   #@items = Offer::Store.search(params[:search]).sort_by{|i| i.location_id }.sort_by{|i| i.rohs }.sort_by{|i| i.body_name }.sort_by{|i| i.brend_name }.sort_by{|i| i.name}
   CartItem.uncached do
    @carts = CartItem.where(:user_id => current_user.id).in_cart.unprocessed.order("product_name, product_brend").all
    @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
   end
   @stores = @carts.map(&:location_link).uniq.compact
   @avail_sales = Axapta.sales_info_paged(1, :status_filter => 'backorder', :records_per_page => 64000).process{|sales|  [""] + sales.map{|s| [s.sales_id, s.sales_id] }}
   chk_err(@items)
   @reqs = @carts.partition{|i| i.is_a? CartRequest }[0]
   @nreqs = @carts.partition{|i| i.is_a? CartRequest }[1]
   @deliveries = User.current.deliveries
   chk_err(@deliveries)
   @use_alt_price = false if @items.detect{|i| i.alt_prices.size > 0 }
   gon.need_application = @carts.detect{|i| i.application_area_mandatory } #TODO: clean gon
   @app_list = Axapta.application_area_list
   chk_err(@app_list)
   gon.app_list = @app_list #TODO: clean gon
   @mandatory = @carts.detect{|c| c.application_area_mandatory }
   flash[:info] = t "errors.search.empty" if @items.empty?
   flash[:info] = t "errors.search.ambiq" if @items.ambiq
  end

  def export
   respond_with do |format|
    format.csv do
     send_data CartItem.export(:csv, :cart, User.current.cart_items.unprocessed.in_cart.all), :type => "application/csv", :disposition => 'attachment', :filename => "export_#{User.current.current_account.business}_#{[params[:controller].to_s, params[:action].to_s].join('_')}_#{Date.today.strftime("%Y%m%d")}.csv"
    end
   end
  end

  def dms
   @after = params[:after]
   @seek = params[:name]
   @code = params[:code]
   @brend = params[:brend]
   @items = @code.blank? ? Offer::World.by_query(@seek, @brend) : Offer::World.by_code(@code)
   chk_err(@items)
   @carts = User.current.cart_items.in_cart.unprocessed.order("product_name, product_brend").all
   @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
   @app_list = Axapta.application_area_list
   chk_err(@app_list)
   @stores = @carts.map(&:location_link).uniq.compact
   @errors << {:info => t("errors.search.empty")} if @items.empty?
   @errors << {:info => t("errors.search.ambiq")} if @items.ambiq
   respond_with do |format|
    format.json do
     crt = render_to_string(:partial => "carts/cart_table.html.haml", :locals => {:cart => @carts, :app_list => @app_list, :stores => @stores})
     render :json => {:row_id => @after, :code => @code, :dms => render_to_string( :partial => "main/dms_block.html.haml", :locals => {:items => @items, :after => @after} ), :gap => render_to_string( :partial => "main/gap_line.html.haml", :locals => {:after => @after}), :empty => render_to_string(:partial => "main/dms_empty.html.haml", :locals => {:after => @after}), :cart => crt, :error => @errors}
    end
    format.html do
     
     redirect_to root_path
    end
   end
  end

  def conv_dms_items(items)
   items.inject([]) do |r, i|
    i["prognosis"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_multiples" => loc["qty_multiples"], "max_qty" => loc["vend_qty"], "rohs" => i["rohs"], "prognosis_id" => loc["prognosis_id"]}#, "min_qty" => i["min_qty"], "location_id" => loc["location_id"]
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"], "min_qty" => locs[0]["min_qty"], "vend_proposal_date" => locs[0]["vend_proposal_date"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
     a.merge!("need_more" => true) if loc["price_qty"].size > 4
     r << a
    end
    r
   end

  end

  def mass_dms
   @items = Offer::World.by_query(params[:query_string])
   chk_err(@items)
   hsh = @items.inject({}) do |r, item|
    i = item.base_signature
    unless r.has_key?(i)
     r[i] = []
    end
    r[i] << item
    r
   end
   dat = {}
   hsh.keys.each do |k|
    dat[k] = render_to_string :partial => "main/dms_block.html.haml", :locals => {:items => hsh[k], :after => k}
   end
   @carts = User.current.cart_items.unprocessed.in_cart.order("product_name, product_brend")
   @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
   @mandatory = @carts.detect{|i| i.application_area_mandatory }
   @app_list = Axapta.application_area_list
   chk_err(@app_list)
   @stores = @carts.map(&:location_link).uniq.compact.sort{|a, b| a == User.current.current_account.invent_location_id ? -1 : a <=> b }
   @carts.each do |cart|
    cart.line = render_to_string :partial => "carts/cart_line.html.haml", :locals => {:cart_line => cart, :app_list => @app_list}
    cart.offer_code = cart.signature
    cart.line_code = cart.base_signature
   end
   @rendered = render_to_string :partial => "carts/cart_table.html.haml", :locals => {:cart => @carts, :app_list => @app_list, :stores => @stores}
   respond_with do |format|
    format.json { render :json => {:dms => dat, :cart => @rendered, :error => @errors} }
   end
  end

  def analog
   @after = params[:after]
   @code = params[:code]
   data = Offer::Analog.analogs(@code)
   chk_err(data)
   @items = data
   @carts = User.current.cart_items.unprocessed.in_cart.order("product_name, product_brend")
   @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
   @mandatory = @carts.detect{|i| i.application_area_mandatory }
   @app_list = Axapta.application_area_list
   chk_err(@app_list)
   @stores = @carts.map(&:location_link).uniq.compact.sort{|a, b| a == User.current.current_account.invent_location_id ? -1 : a <=> b }
   @carts.each do |cart|
    cart.line = render_to_string :partial => "carts/cart_line.html.haml", :locals => {:cart_line => cart, :app_list => @app_list}
    cart.offer_code = cart.signature
    cart.line_code = cart.base_signature
    #cart.line = view_context.escape_javascript(render_to_string :partial => "carts/cart_line", :locals => {:cart_line => cart})
   end
   @rendered = render_to_string :partial => "carts/cart_table.html.haml", :locals => {:cart => @carts, :app_list => @app_list, :stores => @stores}
   respond_with do |format|
    format.json { render :json => {:row_id => @after, :code => @code, :gap => render_to_string(:partial => "main/gap_line.html.haml", :locals => {:after => @after}), :hdr => render_to_string(:partial => "main/analog_header.html.haml", :locals => {:after => @after}), :analogs => render_to_string(:partial => "main/analog_line.html.haml", :collection => @items, :locals => {:after => @after}), :empty => render_to_string(:partial => "main/analog_empty.html.haml", :locals => {:after => @after}), :cart => @rendered}, :layout => false }
   end
  end

  def info
   @after = params[:after]
   @location = params[:loc]
   @code = params[:code]
   locs = Axapta.search_names(:item_id_search => @code).process{|n| n.first.locations.map{|l| l["location_id"] }}
   chk_err(locs)
   @data = Axapta.item_info({:item_id => @code})
   chk_err(@data)
   @data.prices = Axapta.retail_price(:item_id => @code)
   chk_err(@data.prices)
   @data.dates = locs.inject({}) do |r, l|
    prg = Axapta.get_delivery_prognosis(@code, l)
    chk_err(prg)
    r[l] = prg.send(l)
   end
   respond_with do |format|
    format.json { render :json => {:row_id => @after, :code => @code, :gap => render_to_string(:partial => "main/gap_line.html.haml", :locals => {:after => @after}), :info => render_to_string(:partial => "main/info_block.html.haml", :locals => {:after => @after, :info_block => @data})} }
   end

  end

  def set
   val = params[:value] || false
   stor = Setting.by_user(current_user.id).by_name(params[:id]).first || Setting.by_user(current_user.id).by_name(params[:id]).new
   stor.value = val
   stor.save!
   respond_with do |format|
    format.json do
     render :nothing => true
    end
   end
  end

  def manager_request
   @request = OpenStruct.new(params[:request]) unless params[:request].blank?
   cart = CartRequest.create :user_id => User.current.id, :product_name => @request.request_string, :amount => @request.requested_count, :comment => @request.manager_comment
   chk_err(cart)
   redirect_to :back
   # запросить 
  end

  def help
   @help = HelpArticle.find(params[:id])
   render :help, :layout => "simple"
  end

  def feedback
   uhsh = {"0" => :support, "1" => :feedback}
   Employee.send(uhsh.fetch(params[:mail_type], :feedback), User.current.current_account, params[:person_name] || User.current.current_account.name, params[:person_email] || User.current.current_account.empl_email, params[:message_subject], params[:message_body], params[:message_upload]).deliver
   redirect_to :back
  end

  def profile
   @profile = OpenStruct.new(:only_my => Setting.get("order.only_my"), :only_store => Setting.get("search.only_store"), :only_available => Setting.get("search.only_available"), :show_box => Setting.get("search.show_box"), :reservation_end => Setting.get('order.reservation_end'), :area_list => Setting.get('cart.area_list'))
  end

  def update_profile
   lut = {:only_store => "search.only_store", :only_my => "order.only_my", :only_available => "search.only_available", :show_box => "search.show_box", :reservation_end => 'order.reservation_end', :area_list => 'cart.area_list'}
   Setting.set_all(params[:profile].inject({}){|r, (k, v)| lut.has_key?(k) ? r.merge(lut[k] => v) : r.merge(k => v) })
   redirect_to profile_path
  end

  def qnames
   nmes = Axapta.search_item_name_quick(params[:query])
   chk_err(nmes)
   respond_with do |format|
    format.json do
     render :json => nmes, :error => @errors
    end
   end
   
  end
 protected

end
