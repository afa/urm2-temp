require "ostruct"
require "web_utils"
class MainController < ApplicationController

 respond_to :js, :html, :json

 skip_before_filter :check_account_cur, :only => [:index]
 #before_filter :get_users, :only => [:index]
 #before_filter :get_accounts, :only => [:index, :search, :extended]
 #before_filter :check_account#, :only => [:search, :extended, :dms]
  def index
   @news = NewsArticle.order("created_at desc").all
  end

  def search
   @only_store = params[:search].try(:[], :only_store) || false
   stor = current_user.settings.where(:name => "search.only_store").first || current_user.settings.where(:name => "search.only_store").new
   stor.value = @only_store
   stor.save!
   gon.only_store = WebUtils.to_bool(@only_store)
   @only_available = params[:search].try(:[], :only_available) || false
   avail = current_user.settings.where(:name => "search.only_available").first || current_user.settings.where(:name => "search.only_available").new
   avail.value = @only_available
   avail.save!
   @items = Offer::Store.search(params[:search])
   CartItem.uncached do
    @carts = CartItem.where(:user_id => current_user.id).in_cart.unprocessed.order("product_name, product_brend").all
   end
   @stores = @carts.map(&:location_link).uniq.compact
   @reqs = @carts.partition{|i| i.is_a? CartRequest }[0]
   @nreqs = @carts.partition{|i| i.is_a? CartRequest }[1]
   @deliveries = User.current.deliveries
   @use_alt_price = false if @items.detect{|i| i.alt_prices.size > 0 }
   gon.need_application = @carts.detect{|i| i.application_area_mandatory }
   @app_list = Axapta.application_area_list || []
   gon.app_list = @app_list

  end

  def dms
   @after = params[:after]
   @seek = params[:name]
   @code = params[:code]
   @brend = params[:brend]
   @items = @code.blank? ? Offer::World.by_query(@seek, @brend) : Offer::World.by_code(@code)
   #@hash = current_user.current_account.try(:axapta_hash)
   #@items = conv_dms_items(Axapta.search_dms_names(:user_hash => @hash, :item_id_search => @code, :query_string => @seek, :search_brend => @brend))
   #CartWorld.prepare_codes(@items)
   respond_with do |format|
    format.json do
     render :json => {:dms => render_to_string( :partial => "main/dms_block.html", :locals => {:items => @items, :after => @after} ), :gap => render_to_string( :partial => "main/gap_line.html", :locals => {:after => @after}), :empty => render_to_string(:partial => "main/dms_empty.html", :locals => {:after => @after})}
    end
    format.js { render :layout => false }
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
   puts "---mass dms start #{Time.now}"
   @hash = current_user.current_account.try(:axapta_hash)
   @items = Offer::World.by_query(params[:query_string])
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
    dat[k] = render_to_string :partial => "main/dms_block.html", :locals => {:items => hsh[k], :after => k}
   end
   respond_with do |format|
    format.json { render :json => dat }
   end
  end

  def analog
   @after = params[:after]
   @code = params[:code]
   #@hash = current_user.current_account.try(:axapta_hash)
   
   logger.info "--- request_start: #{Time.now}"
   begin
    data = Offer::Store.analogs(@code)
   rescue Exception => e
    p "---exc in Main#analog:search #{Time.now}", e
    logger.info e.to_s
   end
   @items = data
  end

  def info
   @after = params[:after]
   @code = params[:code]
   @hash = current_user.current_account.try(:axapta_hash)
   logger.info "--- request_start: #{Time.now}"
   begin
    @data = Axapta.item_info({:user_hash => @hash, :item_id => @code})
   rescue Exception => e
    p "---exc in info #{Time.now}", e, e.backtrace
    logger.info e.to_s
    @data = {}
   end
   begin
    @data["prices"] = Axapta.retail_price(:user_hash => @hash, :item_id => @code)
   rescue Exception => e
    p "---exc in retail #{Time.now}", e, e.backtrace
    logger.info e.to_s
    @data["prices"] = []
   end
   respond_with do |format|
    format.js { render :layout => false }
   end

  end

  def set
   val = params[:value] || false
   stor = current_user.settings.where(:name => params[:id]).first || current_user.settings.where(:name => params[:id]).new
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
   redirect_to :back
   # запросить 
  end

  def help

  end
 protected
  #def get_accounts
  # @accounts = current_user.accounts.where(:blocked => false)
  #end

  #def check_account
  # if current_user.current_account
  #  if current_user.current_account.blocked? or current_user.accounts.where(:id => current_user.current_account_id).count == 0
  #   redirect_to root_path
  #  end
  # else
  #  redirect_to root_path
  # end
  #end

end
