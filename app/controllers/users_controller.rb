class UsersController < ApplicationController
 skip_before_filter :authenticate!, :only => [:new, :create]
 skip_before_filter :check_account, :only => [:new, :create]
 before_filter :get_user, :only => [:edit, :update, :show, :destroy]
 before_filter :check_user, :only => [:edit, :update, :show, :destroy]
 before_filter :get_accounts, :only => [:edit, :update]
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
   @user = User.create(params[:user])
   if @user.valid?
    flash[:info] = "ok"
   else
    flash[:error] = "fail"
    render :new
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
   account_id = params[:current_account][:account]
   if account_id.blank?
    current_user.update_attributes :current_account_id => nil
    redirect_to root_path, :flash => {:info => t(:account_deselected)}
   else
    account = current_user.accounts.where(:blocked => false).find_by_id(account_id)
    if account
     if current_user.update_attributes :current_account_id => account.id
      redirect_to root_path
     else
      redirect_to root_path, :flash => {:error => t(:error_selecting_account)}
     end
    else
     current_user.update_attributes :current_account_id => nil
     redirect_to root_path, :flash => {:info => t(:account_deselected)}
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
end
