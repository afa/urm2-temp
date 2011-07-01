class Admin::SessionsController < Admin::ApplicationController
 skip_before_filter :authenticate!, :only => [:new, :create]

  def new
  end

  def create
   session[:manager] = Manager.authenticate(params[:session].try(:[], :name), params[:session].try(:[], :password)) unless logged_in?
   redirect_to admin_root_path if session[:manager]
   redirect_to new_admin_session_path unless session[:manager]
  end

  def destroy
   session[:manager] = nil
   redirect_to new_admin_session_path
  end

end
