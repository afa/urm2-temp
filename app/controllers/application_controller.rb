class ApplicationController < ActionController::Base
  before_filter :authenticate!
  before_filter :get_accounts
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
    puts "::: user_from_cookie"
    p token
    u = User.find_by_remember_token(token)
    cookies.delete(:user_remember_token) unless u
    u
   else
    nil
   end
  end

  def current_user
   User.current ||= user_from_cookie
  end

  def current_user=(user)
   User.current = user
  end

  def authenticate!
   unless logged_in?
    redirect_to new_sessions_path
   end
  end

  def logged_in?
   not current_user.blank?
  end

  def get_accounts
   if logged_in?
    @accounts = current_user.accounts.where(:blocked => false)
   else
    @accounts = []
   end
  end

  def take_search
   srch = params[:search] || {}
   if logged_in?
    srch[:only_available] = current_user.settings.where(:name => 'search.only_available').first.try(:value) if srch[:only_available].nil?
    srch[:only_store] = current_user.settings.where(:name => 'search.only_store').first.try(:value) if srch[:only_store].nil?
   end
   @search = OpenStruct.new(srch)
  end
end
