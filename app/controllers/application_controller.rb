class ApplicationController < ActionController::Base
  before_filter :authenticate!
  before_filter :take_search
  protect_from_forgery

  def sign_in(user)
   if user
    cookies[:user_remember_token] = {
      :value   => user.remember_token,
      :expires => 1.day.from_now.utc
    }
    self.current_user = user
   end
  end

  def sign_out
   self.current_user.reset_remember_token! if self.current_user
   cookies.delete(:user_remember_token)
   self.current_user = nil
  end

 protected
  def user_from_cookie
   if token = cookies[:user_remember_token]
    User.find_by_remember_token(token)
   end
  end

  def current_user
   @current_user ||= user_from_cookie
  end

  def current_user=(user)
   @current_user = user
  end

  def authenticate!
   unless logged_in?
    redirect_to new_sessions_path
   end
  end

  def logged_in?
   not current_user.blank?
  end

  def take_search
   @search = OpenStruct.new(params[:search] || {})
  end
end
