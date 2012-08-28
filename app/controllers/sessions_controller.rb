# coding: UTF-8
class SessionsController < ApplicationController

 skip_filter :login_from_cookie, :except => :destroy
 skip_before_filter :authenticate!, :except => :destroy
 skip_before_filter :check_account_cur, :except => :destroy
 skip_before_filter :get_accounts_in, :except => :destroy
 skip_before_filter :take_search
 
 #skip_before_filter :authenticate!, :only => [:new, :create]
 layout false

  def new
  end

  def create
   sign_out if logged_in?
   l_user = User.authenticate(params[:session].try(:[], :username), params[:session].try(:[], :password))
   unless l_user
    User.current = nil
    redirect_to new_sessions_path, :flash => {:error => "Неверный пароль или имя пользователя."} 
    return
   end
   sign_in(l_user, :rememberme => params[:rememberme]) #unless logged_in?
   if logged_in?
    current_user.reload_accounts
    redirect_to root_path
   else
    redirect_to new_sessions_path, :flash => {:error => "Неверный пароль или имя пользователя."}
   end
  end

  def destroy
   sign_out
   redirect_to new_sessions_path
  end
end
