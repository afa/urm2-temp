class Admin::SessionsController < Admin::ApplicationController
 skip_before_filter :authenticate!, :only => [:new, :create]

  def new
  end

  def create
   sign_in(Manager.authenticate(params[:session].try(:[], :name), params[:session].try(:[], :password))) unless logged_in?
   redirect_to admin_root_path if logged_in?
   redirect_to new_admin_session_path unless logged_in?
  end

  def destroy
   sign_out
   #current_user.reset_remember_token!
   #session[:manager] = nil
   redirect_to new_admin_session_path
  end

end
