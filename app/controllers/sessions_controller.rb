class SessionsController < ApplicationController

 skip_before_filter :authenticate!, :except => :destroy
 skip_before_filter :check_account
 skip_before_filter :get_accounts
 skip_before_filter :take_search
 
 #skip_before_filter :authenticate!, :only => [:new, :create]
 layout false

  def new
  end

  def create
   sign_in(User.authenticate(params[:session].try(:[], :username), params[:session].try(:[], :password))) #unless logged_in?
   current_user.reload_accounts if logged_in?
   redirect_to root_path if logged_in?
   redirect_to new_sessions_path, :flash => {:error => "Неверный пароль или имя пользователя."} unless logged_in?
  end

  def destroy
   User.current.settings.update_all("value = '0'", "name = 'hideheader'")
   sign_out
   redirect_to new_sessions_path
  end
end
