module Admin::ApplicationHelper
# def user_from_cookie
#  if token = cookies[:manager_remember_token]
#   Manager.find_by_remember_token(token)
#  end
# end
 def current_user
  @current_user
 end
 def logged_in?
  not @current_user.blank?
 end
end
