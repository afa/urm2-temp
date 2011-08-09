class AccountsController < ApplicationController

 before_filter :get_user
 before_filter :get_account, :only => [:show, :edit, :update, :destroy]
 before_filter :get_accounts, :only => :index
  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
   if @user.accounts.create params[:account]
    redirect_to user_accounts_path(@user)
   else
    @account = @user.accounts.new(params[:account] || {})
    render :new
   end
  end

  def update
   if @account.update_attributes params[:account]
    redirect_to user_accounts_path(@user)
   else
    render :edit
   end
  end

  def destroy
   if @account
    @account.destroy
   end
   redirect_to user_accounts_path(@user)
  end

 protected
  def get_user
   @user = User.find(params[:user_id])
  end

  def get_account
   @account = @user.accounts.find params[:id]
  end

  def get_accounts
   @accounts = @user.accounts
  end
end
