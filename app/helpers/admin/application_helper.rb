module Admin::ApplicationHelper
# def user_from_cookie
#  if token = cookies[:manager_remember_token]
#   Manager.find_by_remember_token(token)
#  end
# end
 def current_user
  User.current
 end
 def logged_in?
  not User.current.blank?
 end
end
