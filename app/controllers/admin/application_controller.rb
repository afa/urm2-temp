class Admin::ApplicationController < ActionController::Base
  layout "admin/application"
  helper Admin::ApplicationHelper
  skip_before_filter :login_from_cookie
  skip_before_filter :authenticate!
  before_filter :man_authenticate!
  protect_from_forgery
   def sign_in(user)
    if user
     cookies[:manager_remember_token] = {
      :value   => user.remember_token,
      :expires => 1.year.from_now.utc
     }
     self.current_user = user
    end
   end

   def sign_out
    self.current_user.reset_remember_token! if self.logged_in?
    cookies.delete(:manager_remember_token)
    self.current_user = nil
   end

    protected

    def user_from_cookie
      if token = cookies[:manager_remember_token]
        Manager.find_by_remember_token(token)
      end
    end

  def man_authenticate!
   unless logged_in?
    redirect_to new_admin_session_path
   end
  end

 def current_user
  User.current = user_from_cookie unless logged_in?
 end

 def current_user=(user)
  User.current = user
 end

 def logged_in?
  User.logged?
 end
end
