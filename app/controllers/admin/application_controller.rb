class Admin::ApplicationController < ActionController::Base
  layout "admin/application"
  helper Admin::ApplicationHelper
  before_filter :authenticate!
 #include Clearance::Authentication

 #def authenticate(params)
 # User.authenticate(params[:session][:username],
 #                   params[:session][:password])
 #end
  protect_from_forgery
 protected
  def authenticate!
   unless logged_in?
    redirect_to new_admin_session_path
   end
  end

 def current_user
  @current_user ||= Manager.find_by_id(session[:manager]) #fix for remember-token use
 end

 def logged_in?
  not current_user.blank?
 end
end
