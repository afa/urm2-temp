class SessionsController < ApplicationController
 skip_filter :authenticate!, :except => :destroy
 skip_filter :check_account
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
   sign_out
   redirect_to new_sessions_path
  end
end
