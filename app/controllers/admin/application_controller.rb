class Admin::ApplicationController < ActionController::Base
  layout "admin/application"
  helper Admin::ApplicationHelper
  before_filter :authenticate!
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
    self.current_user.reset_remember_token! if self.current_user
    cookies.delete(:remember_token)
    self.current_user = nil
   end

    protected

    def user_from_cookie
      if token = cookies[:manager_remember_token]
        Manager.find_by_remember_token(token)
      end
    end

  def authenticate!
   unless logged_in?
    redirect_to new_admin_session_path
   end
  end

 def current_user
  @current_user ||= user_from_cookie
 end

 def current_user=(user)
  @current_user = user
 end

 def logged_in?
  not current_user.blank?
 end
end
