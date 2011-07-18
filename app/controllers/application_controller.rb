class ApplicationController < ActionController::Base
  before_filter :authenticate!
  protect_from_forgery


 protected
  def authenticate!
   unless logged_in?
    redirect_to new_sessions_path
   end
  end

 def current_user
  @current_user ||= User.find_by_id(session[:user]) #fix for remember-token use
 end

 def logged_in?
  not current_user.blank?
 end
end
