module Admin::ApplicationHelper
 include Afauth::Controller::Helper
# def user_from_cookie
#  if token = cookies[:manager_remember_token]
#   Manager.find_by_remember_token(token)
#  end
# end
 def current_user
  controller.current_user
 end
 def logged_in?
  not controller.current_user.blank?
 end
end
