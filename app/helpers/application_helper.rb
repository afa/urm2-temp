module ApplicationHelper
 def current_user
  @current_user ||= User.find_by_id(session[:user])
 end
 def logged_in?
  current_user?
 end
end
