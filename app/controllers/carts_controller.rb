class CartsController < ApplicationController
 respond_to :js, :html, :json
  def index
   @carts = User.current.cart_items.unprocessed.in_cart.order("product_name, product_brend")
   @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
   @deliveries = User.current.deliveries
  end

  def new
  end

  def create
   @changed = []
   #if params[:items] and !params[:items].blank?
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
    CartItem.uncached do
     @carts = User.current.cart_items.unprocessed.in_cart.order("product_name, product_brend")
     @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
     #gon.need_application = @carts.detect{|i| i.application_area_mandatory }
     @app_list = Axapta.application_area_list || []
     #gon.app_list = @app_list
     @stores = @carts.map(&:location_link).uniq.compact.sort{|a, b| a == User.current.current_account.invent_location_id ? -1 : a <=> b }
     @carts.each do |cart|
      cart.line = render_to_string :partial => "carts/cart_line", :locals => {:cart_line => cart, :app_list => @app_list}
      cart.offer_code = cart.signature
      cart.line_code = cart.base_signature
      #cart.line = view_context.escape_javascript(render_to_string :partial => "carts/cart_line", :locals => {:cart_line => cart})
     end
     @rendered = render_to_string :partial => "carts/cart_collection", :locals => {:cart => @carts, :app_list => @app_list, :stores => @stores}
     #gon.rendered = @rendered
     #gon.carts = @carts.map{|c| c.to_hash.merge(:obj_id => c.id)}
     #gon.changes = @changed
     #gon.stores = @stores
     @deliveries = User.current.deliveries
     sales = Axapta.sales_info_paged(1, :status_filter => 'backorder', :records_per_page => 64000).items
     @sales_locs = sales.map{|s| [s.sales_id, s.location_id] }.as_hash
     @avail_sales = sales.map{|s| [s.sales_id, s.sales_id] }
     #gon.order = render_to_string :partial => "main/order_edit.html.haml"
    end
    #redirect_to carts_path
    respond_with do |format|
     format.json do
      render :json => {:need_application => @carts.detect{|i| i.application_area_mandatory }, :app_list => (Axapta.application_area_list || []).sort_by{|l| l.application_area_name }, :rendered => render_to_string(:partial => "carts/cart_table.html.haml", :locals => {:cart => @carts, :app_list => @app_list, :stores => @stores}) }
      #render :json => {:dms => render_to_string( :partial => "main/dms_block.html", :locals => {:items => @items, :after => @after} ), :gap => render_to_string( :partial => "main/gap_line.html", :locals => {:after => @after}), :empty => render_to_string(:partial => "main/dms_empty.html", :locals => {:after => @after})}
     end
     #format.js { render :layout => false }
     #format.html do
     # redirect_to carts_path
     #end
    end
   #else
   # redirect_to :back
   #end
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
    hsh = params[:cart_item][cart.id.to_s]
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
    [:destroy, :pick, :reserve].each{|s| hsh[s] = WebUtils.parse_bool(hsh[s]) if hsh.has_key?(s) }
    v_destroy = hsh[:destroy]
    hsh.reject!{|k,v| k == :destroy or k == 'destroy' }
    if v_destroy
     cart.update_attributes hsh.merge(:amount => 0)
     @changed << [cart.id.to_s, '0']
    else
     cart.update_attributes hsh
     @changed << [cart.id.to_s, cart.amount.to_s]
    end
   end
   CartItem.uncached do
    @carts = User.current.cart_items.unprocessed.in_cart.order("product_name, product_brend")
    @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
    @stores = @carts.map(&:location_link).uniq.compact.sort{|a, b| a == User.current.current_account.invent_location_id ? -1 : a <=> b }
    @deliveries = User.current.deliveries
    gon.need_application = @carts.detect{|i| i.application_area_mandatory }
    @app_list = Axapta.application_area_list || []
    gon.app_list = @app_list
    @carts.each do |cart|
     #cart.line = render_to_string :partial => "carts/cart_line", :locals => {:cart_line => cart, :app_list => @app_list}
     cart.offer_code = cart.signature
     cart.line_code = cart.base_signature
    end
    #@stores = @carts.map(&:location_link).uniq.compact
    @rendered = render_to_string :partial => "carts/cart_collection", :locals => {:cart => @carts, :app_list => @app_list, :stores => @stores}
    gon.rendered = @rendered
    gon.carts = @carts.map{|c| c.to_hash.merge(:obj_id => c.id)}
    gon.stores = @stores
    sales = Axapta.sales_info_paged(1, :status_filter => 'backorder', :records_per_page => 64000).items
    @sales_locs = sales.map{|s| [s.sales_id, s.location_id] }.as_hash
    @avail_sales = sales.map{|s| [s.sales_id, s.sales_id] }
    @order = render_to_string :partial => "main/order_edit.html.haml"
    gon.order = @order
   end
   respond_with do |format|
    format.js { render :layout => false }
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
   @app_list = Axapta.application_area_list || []
   gon.app_list = @app_list
   CartItem.uncached do
    @carts = User.current.cart_items.unprocessed.in_cart.order("product_name, product_brend")
    @carts.select{|c| c.is_a?(CartWorld) }.each{|c| c.location_link = User.current.current_account.invent_location_id }
    @stores = @carts.map(&:location_link).uniq.compact.sort{|a, b| a == User.current.current_account.invent_location_id ? -1 : a <=> b }
    gon.need_application = @carts.detect{|i| i.application_area_mandatory }
    @carts.each do |cart|
     cart.line = render_to_string :partial => "carts/cart_line", :locals => {:cart_line => cart, :app_list => @app_list}
     cart.offer_code = cart.signature
     cart.line_code = cart.base_signature
     #cart.line = view_context.escape_javascript(render_to_string :partial => "carts/cart_line", :locals => {:cart_line => cart})
    end
    @rendered = render_to_string :partial => "carts/cart_collection", :locals => {:cart => @carts, :app_list => @app_list, :stores => @stores}
    gon.rendered = @rendered
    gon.carts = @carts.map{|c| c.to_hash.merge(:obj_id => c.id)}
    gon.deleted = @old
    #@stores = @carts.map(&:location_link).uniq.compact
    #gon.changes = @changed
    @deliveries = User.current.deliveries
    gon.stores = @stores
    sales = Axapta.sales_info_paged(1, :status_filter => 'backorder', :records_per_page => 64000).items
    @sales_locs = sales.map{|s| [s.sales_id, s.location_id] }.as_hash
    @avail_sales = sales.map{|s| [s.sales_id, s.sales_id] }
    gon.order = render_to_string :partial => "main/order_edit.html.haml"
   end

   respond_with do |format|
    format.js { render :layout => false }
    #format.json { render :json => {:carts_table => escape_javascript(render_to_string(:partial => "carts/cart_table", :locals => {:cart => @carts})), :old => @old, :new => @new, :carts_empty => @carts.empty?} }
   end
  end
end
