#coding: UTF-8
class UsersController < ApplicationController
 respond_to :js, :html, :json, :csv, :xls
 skip_before_filter :process_cookie, :only => [:new, :create]
 skip_before_filter :login_from_cookie, :only => [:new, :create]
 skip_before_filter :authenticate!, :only => [:new, :create]
 skip_before_filter :check_account, :only => [:new, :create]
 skip_before_filter :check_account_cur, :only => [:new, :create]
 skip_before_filter :get_accounts_in, :only => [:new, :create]
 skip_before_filter :take_search, :only => [:new, :create]
 before_filter :get_user, :only => [:edit, :update, :show, :destroy]
 before_filter :check_user, :only => [:edit, :update, :show, :destroy]
 before_filter :get_accounts, :only => [:edit, :update]
 before_filter :get_filter, :only => [:balance, :export_balance, :sold_orders, :export_sold_orders]
  def index
   @children = current_user.axapta_children
   @parent = current_user.parent
  end

  def show
  end

  def new
   @user = User.new
   render :layout => "simple"
  end

  def edit
  end

  def create
   @user = User.new(params[:user])
   begin
    if @user.valid?
     @user.save
     flash[:info] = "ok"
     render :layout => "simple"
    else
     flash[:error] = "fail"
     render :new, :layout => "simple"
    end
   rescue Exception => er
    flash[:error] = "fail"
    render :new, :layout => "simple"
   end
  end

  def update
   if @user.update_attributes params[:user]
    redirect_to users_path
   else
    flash.now[:error] = 'fail'
    render :edit
   end
  end

  def destroy
  end

  def current_account
   #TODO: не менять аккаунт при ошибках?
   account_id = params[:current_account][:account]
   if account_id.blank?
    current_user.update_attributes :current_account_id => nil
    redirect_to root_path, :flash => {:info => t(:account_deselected)}
   else
    account = current_user.accounts.where(:blocked => false).find_by_id(account_id)
    if account
     if current_user.update_attributes :current_account_id => account.id
      current_user.cart_items.in_cart.unprocessed.destroy_all
      redirect_to root_path, :flash => {:info => t(:info_account_changed)}
     else
      redirect_to root_path, :flash => {:error => t(:error_selecting_account)}
     end
    else
     current_user.update_attributes :current_account_id => nil
     redirect_to root_path, :flash => {:info => t(:account_deselected)}
    end
   end
  end

  def account_info
   respond_with do |format|
    format.json do
     render :json => {:account => {:name => User.current.current_account.name, :mail => User.current.current_account.empl_email}} #render_to_string( :partial => "main/dms_block.html", :locals => {:items => @items, :after => @after} ), :gap => render_to_string( :partial => "main/gap_line.html", :locals => {:after => @after}), :empty => render_to_string(:partial => "main/dms_empty.html", :locals => {:after => @after})}
    end
    #format.js { render :layout => false }
   end
  end

  def limits
   @info = Axapta.info_cust_limits
   chk_err(@info)
  end

  def balance
   @info = Axapta.info_cust_balance
   chk_err(@info)
   @currencies = @info.map(&:currency).uniq
   @companies = @info.map(&:company).uniq
   tr = Axapta.info_cust_trans(@filter_hash)
   chk_err(tr)
   @transes = tr.select{|t| @filter.company.blank? ? true : t.company_code == @filter.company }.select{|t| @filter.currency.blank? ? true : t.currency_code == @filter.currency }.map{|i| i.trans_type = Hash[YAML.load(Setting.get("hash.trans_type")).zip(YAML.load(Setting.get("hash.trans_type_rus")))][i.trans_type]; i }
  end

  def export_balance
   respond_with do |format|
    format.csv do
     send_data User.export(:csv, :balance, Axapta.info_cust_trans(@filter_hash).select{|t| @filter.company.blank? ? true : t.company_code == @filter.company }.select{|t| @filter.currency.blank? ? true : t.currency_code == @filter.currency }), :type => "application/csv", :disposition => "attachment", :filename => "export_#{User.current.current_account.business}_#{[params[:controller].to_s, params[:action].to_s].join('_')}_#{Date.today.strftime("%Y%m%d")}.csv"
    end
    format.xls do
     send_data User.export(:xls, :balance, Axapta.info_cust_trans(@filter_hash).select{|t| @filter.company.blank? ? true : t.company_code == @filter.company }.select{|t| @filter.currency.blank? ? true : t.currency_code == @filter.currency }), :type => "application/vnd.ms-excel", :disposition => "attachment", :filename => "export_#{User.current.current_account.business}_#{[params[:controller].to_s, params[:action].to_s].join('_')}_#{Date.today.strftime("%Y%m%d")}.xls"
    end
   end
  end

  def sold_orders
   @filter.date_to = Date.current.strftime("%Y-%m-%d") if @filter.date_to.blank?
   @filter.date_from = 1.month.ago.strftime("%Y-%m-%d") if @filter.date_from.blank?
  end

  def export_sold_orders
   @filter.date_to = Date.current.strftime("%Y-%m-%d") if @filter.date_to.blank?
   @filter.date_from = 1.month.ago.strftime("%Y-%m-%d") if @filter.date_from.blank?
   @filter_hash.merge!(:date_to => @filter.date_to, :date_from => @filter.date_from)
   unless params[:format]
    redirect_to sold_orders_users_path, :flash => {:error => "не задан формат"}
    return
   end
   respond_with do |format|
    format.csv do
     #!!!!!! use sales_report when ready
     send_data ["Отчет по проданным заказам", "за период с #{@filter.date_from} по #{@filter.date_to}", "Не является финансовым документом. Возможна погрешность округления"].map{|s| "#{s}\n" }.join.encode('Windows-1251') + User.export(:csv, :sold_orders, Axapta.sales_report_all(@filter_hash)), :type => "application/csv", :disposition => 'attachment', :filename => "export_#{User.current.current_account.business}_#{[params[:controller].to_s, params[:action].to_s].join('_')}_#{Date.today.strftime("%Y%m%d")}.csv"
    end
    format.xls do
     #!!!!!! use sales_report when ready
     send_data User.export(:xls, :sold_orders, Axapta.sales_report_all(@filter_hash), {:preheader => [["Отчет по проданным заказам"], ["за период с #{@filter.date_from} по #{@filter.date_to}"], ["Не является финансовым документом. Возможна погрешность округления"]]}), :type => "application/vnd.ms-excel", :disposition => 'attachment', :filename => "export_#{User.current.current_account.business}_#{[params[:controller].to_s, params[:action].to_s].join('_')}_#{Date.today.strftime("%Y%m%d")}.xls"
    end
   end
  end

 protected
  def get_user
   @user = User.find(params[:id])
  end

  def check_user
   redirect_to users_path, :flash => {:error => 'denied'} unless current_user == @user || current_user == @user.parent || @user.axapta_children.include?(current_user)
  end

  def get_accounts
   @accounts = @user.accounts.where(:blocked => false)
  end

  def get_filter
   @filter_hash = params[:filter] || {}
   if @filter_hash[:this_sales_origin].blank?
    @filter_hash[:this_sales_origin]='0'
   end
   @filter = OpenStruct.new(@filter_hash)
   @filter.date_to = Date.current.strftime("%Y-%m-%d") if @filter.date_to.blank?
   @filter.date_from = 1.month.ago.strftime("%Y-%m-%d") if @filter.date_from.blank?
   @filter_hash.merge!(:date_to => @filter.date_to, :date_from => @filter.date_from)
   @page = params[:page] || 1
   p "---ufil", @filter, @filter_hash
  end
end
