module ApplicationHelper
 def current_user
  User.current ||= User.find_by_id(session[:user])
 end
 def logged_in?
  not current_user.blank?
 end
end
