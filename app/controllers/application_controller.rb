class ApplicationController < ActionController::Base
  #before_filter :unmodify
  before_filter :login_from_cookie
  before_filter :authenticate!
  before_filter :check_account_cur
  before_filter :get_accounts_in
  before_filter :take_search
  #before_filter :put_sess
  protect_from_forgery

  def sign_in(user, *opts)
   if user
    val = {
      :value   => user.remember_token
    }
    val.merge!(:expires => 1.day.from_now.utc) if opts.is_a?(Hash) && opts[:rememberme]
    cookies[:user_remember_token] = val
    User.current = user
   end
  end

  def sign_out
   if logged_in?
    User.current.settings.update_all("value = '0'", "name = 'hideheader'")
    User.current.reset_remember_token! 
   end
   cookies.delete(:user_remember_token)
   User.current = nil
  end

 protected
  def user_from_cookie
   token = cookies[:user_remember_token]
   if token
    return nil if token.blank?
    u = User.where(:remember_token => token).first
    #cookies.delete(:user_remember_token) unless u
   end
   u
  end

  def login_from_cookie
   u = user_from_cookie
   if u 
    User.current = u
   end
  end

  def current_user
   User.current# ||= user_from_cookie
  end

  def current_user=(user)
   User.current = user
  end

  def authenticate!
   Rails.logger.info "auth!"
   unless logged_in?
    redirect_to new_sessions_path
   end
  end

  def logged_in?
   User.logged?
  end

  def get_accounts_in
   Rails.logger.info "---get acc"
   if logged_in?
    @accounts = User.current.accounts.where(:blocked => false)
   else
    @accounts = []
   end
  end

  def check_account_cur
   Rails.logger.info "---acc #{User.current.inspect}"
   if User.current and User.current.current_account
    #p "::current_user", current_user
    if User.current.current_account.blocked? or User.current.accounts.where(:id => User.current.current_account_id).count == 0
     Rails.logger.warn "---blocked acc #{User.current.current_account_id}"
     User.current.update_attributes(:current_account => nil)
     if User.current.accounts.where(:blocked => 'f').count == 1
      User.current.update_attributes(:current_account => User.current.accounts.where(:blocked => 'f').first)
     end
     redirect_to root_path
    end
   else
    if User.current && (User.current.current_account.try(:blocked?) or User.current.accounts.where(:id => User.current.current_account_id).count == 0)
     Rails.logger.warn "---blocked acc #{User.current.current_account_id}"
     User.current.update_attributes(:current_account => nil)
     if User.current.accounts.where(:blocked => 'f').count == 1
      User.current.update_attributes(:current_account => User.current.accounts.where(:blocked => 'f').first)
     end
     redirect_to root_path
    end

   end
  end

  def take_search
   srch = params[:search] || {}
   requ = params[:request] || {}
   if logged_in?
    srch[:only_available] = User.current.settings.where(:name => 'search.only_available').first.try(:value) if srch[:only_available].nil?
    srch[:only_store] = User.current.settings.where(:name => 'search.only_store').first.try(:value) if srch[:only_store].nil?
    requ[:only_available] = User.current.settings.where(:name => 'search.only_available').first.try(:value) if srch[:only_available].nil?
    requ[:only_store] = User.current.settings.where(:name => 'search.only_store').first.try(:value) if srch[:only_store].nil?
   end
   @search = OpenStruct.new(srch)
   @request = OpenStruct.new(requ)
   #p ":::search", @search
  end

  def unmodify
   response.headers['Last-Modified'] = Time.zone.now.httpdate
  end

  def put_sess
   #p session
  end
end
