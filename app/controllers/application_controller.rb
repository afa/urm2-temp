class ApplicationController < ActionController::Base
  include Afauth::Controller::App
  #before_filter :unmodify
  before_filter :check_account_cur
  before_filter :get_accounts_in
  before_filter :take_search
  protect_from_forgery
  remembered_cookie_name :user_remember_token
  user_model User
  auth_expired_in_days 1
  redirect_failed_cb lambda { new_sessions_path }


 protected
  def current_user
   User.current# ||= user_from_cookie
  end

  def current_user=(user)
   User.current = user
  end

  def authenticate!
   unless logged_in?
    redirect_to new_sessions_path
   end
  end

  def get_accounts_in
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
  end

  def unmodify
   response.headers['Last-Modified'] = Time.zone.now.httpdate
  end

end
