class CartsController < ApplicationController
 respond_to :js, :html, :json
  def index
   @carts = User.current.cart_items.unprocessed.in_cart.order("product_name, product_brend")
   @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
   @deliveries = User.current.deliveries
   chk_err(@deliveries)
  end

  def new
  end

  def create
   @changed = []
   (params[:items] || {}).reject{|k, v| k == :commit }.reject{|k, v| v[:amount].blank? }.each do |k, v|
    @changed << [v[:cart], CartStore.copy_on_write(v)]
   end
   if params[:analog]
    params[:analog].reject{|k, v| v[:amount].blank? }.each do |k, v|
     @changed << [v[:cart], CartStore.copy_on_write(v)]
    end
   end
   if params[:dms]
    params[:dms].reject{|k, v| v[:amount].blank? }.each do |k, v|
     @changed << [v[:cart], CartWorld.copy_on_write(v)]
    end
   end
   if params[:ask_man]
    params[:ask_man].reject{|k, v| v[:amount].blank? }.each do |k, v|
     @changed << [v[:cart], CartAskMan.copy_on_write(v)]
    end
   end
   CartItem.uncached do
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
    @deliveries = User.current.deliveries
    chk_err(@deliveries)
   end
   respond_with do |format|
    format.json do
     render :json => {:need_application => @carts.detect{|i| i.application_area_mandatory }, :app_list => @app_list.sort_by{|l| l.application_area_name }, :rendered => @rendered, :carts => @carts, :changes => @changed, :error => @errors}
    end
   end
  end

  def edit
  end

  def update
   cart = current_user.cart_items.find(params[:id])
   cart.update_attributes params[:cart_item]
  end

  def save
   @changed = []
   carts = params[:cart_item].keys.map{|i| CartItem.find i }
   carts.each do |cart|
    old = cart.id.to_s
    hsh = params[:cart_item][old]
    act = hsh[:action]
    if act
     case act
      when "pick"
       hsh.merge(:pick => true, :reserve => false)
      when "reserve"
       hsh.merge(:pick => false, :reserve => true)
      else
       hsh.merge(:pick => false, :reserve => false)
     end
    end
    [:pick, :reserve].each{|s| hsh[s] = WebUtils.parse_bool(hsh[s]) if hsh.has_key?(s) }
    cart.update_attributes hsh
    @changed << [old, cart.id.to_s]
   end
   CartItem.uncached do
    @carts = User.current.cart_items.unprocessed.in_cart.order("product_name, product_brend")
    @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
    @stores = @carts.map(&:location_link).uniq.compact.sort{|a, b| a == User.current.current_account.invent_location_id ? -1 : a <=> b }
    @deliveries = User.current.deliveries
    chk_err(@deliveries)
    @mandatory = @carts.detect{|i| i.application_area_mandatory }
    @app_list = Axapta.application_area_list
    chk_err(@app_list)
    #gon.app_list = @app_list
    @carts.each do |cart|
     #cart.line = render_to_string :partial => "carts/cart_line", :locals => {:cart_line => cart, :app_list => @app_list}
     cart.offer_code = cart.signature
     cart.line_code = cart.base_signature
    end
    #@stores = @carts.map(&:location_link).uniq.compact
    @rendered = render_to_string :partial => "carts/cart_table.html.haml", :locals => {:cart => @carts, :app_list => @app_list, :stores => @stores}
    #gon.rendered = @rendered
    #gon.carts = @carts.map{|c| c.to_hash.merge(:obj_id => c.id)}
    #gon.stores = @stores
    #sales = Axapta.sales_info_paged(1, :status_filter => 'backorder', :records_per_page => 64000).items
    #@sales_locs = sales.map{|s| [s.sales_id, s.location_id] }.as_hash
    #@avail_sales = sales.map{|s| [s.sales_id, s.sales_id] }
    #@order = render_to_string :partial => "main/order_edit.html.haml"
    #gon.order = @order
   end
   respond_with do |format|
    #format.js { render :layout => false }
    format.json do
     render :json => {:stores => @stores, :carts => @carts, :rendered => @rendered, :changes => @changed, :error => @errors}
    end
   end
  end

  def destroy
   old = User.current.cart_items.unprocessed.in_cart.find(params[:id])
   #@old.try(:update_attributes, :amount => 0)
   @old = old.id
   #@new = old.setup_for(:amount => 0, :max_amount => old.max_amount).copy_on_write(:amount => 0, :cart => old.id)
   @new = @old
   old.update_attributes(:amount => 0)
   #@new = old.setup_for(:amount => 0, :max_amount => old.max_amount).copy_on_write(:amount => 0, :cart => old.id)
   @deliveries = User.current.deliveries
   chk_err(@deliveries)
   @app_list = Axapta.application_area_list
   chk_err(@app_list)
   #gon.app_list = @app_list
   CartItem.uncached do
    @carts = User.current.cart_items.unprocessed.in_cart.order("product_name, product_brend")
    @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
    @stores = @carts.map(&:location_link).uniq.compact.sort{|a, b| a == User.current.current_account.invent_location_id ? -1 : a <=> b }
    @mandatory = @carts.detect{|i| i.application_area_mandatory }
    @carts.each do |cart|
     cart.line = render_to_string :partial => "carts/cart_line.html.haml", :locals => {:cart_line => cart, :app_list => @app_list}
     cart.offer_code = cart.signature
     cart.line_code = cart.base_signature
    end
    @rendered = render_to_string :partial => "carts/cart_table.html.haml", :locals => {:cart => @carts, :app_list => @app_list, :stores => @stores}
   end

   respond_with do |format|
    format.json do
     render :json => {:rendered => @rendered, :carts => @carts, :deleted => @old, :error => @errors}
    end
   end
  end
end
