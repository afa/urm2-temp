module Admin::ApplicationHelper
 include Afauth::Controller::Helper
 def current_user
  controller.current_user
 end
 def logged_in?
  controller.logged_in?
 end
end
