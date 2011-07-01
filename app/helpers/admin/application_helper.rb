module Admin::ApplicationHelper
 def current_user
  @current_user ||= Manager.find_by_id(session[:user])
 end
 def logged_in?
  not current_user.blank?
 end
end
