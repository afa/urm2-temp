class UsersController < ApplicationController
 skip_before_filter :authenticate!, :only => [:new, :create]
 skip_before_filter :check_account, :only => [:new, :create]
 before_filter :get_user, :only => [:edit, :update, :show, :destroy]
 before_filter :check_user, :only => [:edit, :update, :show, :destroy]
 before_filter :get_accounts, :only => [:edit, :update]
 before_filter :get_filter, :only => [:balance]
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
   @user.save
   if @user.valid?
    flash[:info] = "ok"
    render :layout => "simple"
   else
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

  def limits
   @info = Axapta.info_cust_limits
  end

  def balance
   @info = Axapta.info_cust_balance
   @currencies = @info.map(&:currency)
   @companies = @info.map(&:company)
   unless @filter.blank?
    @transes = Axapta.info_cust_trans(params[:filter])
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
   @filter = OpenStruct.new(params[:filter]) unless params[:filter].blank?
  end
end
