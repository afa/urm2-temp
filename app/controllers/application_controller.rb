class ApplicationController < ActionController::Base
  helper ApplicationHelper
  include Afauth::Controller::App
  remembered_cookie_name :user_remember_token
  user_model User
  auth_expired_in_days 1
  redirect_failed_cb :cb_failed
  before_logout_cb :cb_before_logout
  post_logout_cb :cb_post_logout
  authen_field_name :username
  post_sign_cb :cb_logged
  #before_filter :unmodify
  before_filter :prepare_decor
  before_filter :check_account_cur
  before_filter :get_accounts_in
  before_filter :take_search
  protect_from_forgery


 protected
  def prepare_decor
   @usd_decor = CurrencyPresenter.new(:usd)
   @rub_decor = CurrencyPresenter.new(:rub)
   @price_decor = {
    "RUR" => @rub_decor,
    "USD" => @usd_decor
   }
  end

  def cb_logged
   current_user.reload_accounts
   redirect_to root_path
  end

  def cb_post_logout
   redirect_to root_path
  end

  def cb_failed
   new_sessions_path
  end

  def cb_before_logout
   Setting.by_name("hideheader").by_user(User.current.id).update_all("value = '0'")
   #User.current.settings.update_all("value = '0'", "name = 'hideheader'")
   User.current.reset_remember_token!
  end

  def get_accounts_in
   if logged_in?
    @accounts = User.current.accounts.where(:blocked => false)
   else
    @accounts = []
   end
  end

  def check_account_cur
   if User.logged? and User.current and User.current.current_account
    Rails.logger.info "---acc #{User.current.inspect}"
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
    if User.logged? && User.current && (User.current.current_account.try(:blocked?) or User.current.accounts.where(:id => User.current.current_account_id).count == 0)
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
    srch[:only_available] = Setting.by_user(User.current.id).by_name('search.only_available').first.try(:value) if srch[:only_available].nil?
    srch[:only_store] = Setting.by_user(User.current.id).by_name('search.only_store').first.try(:value) if srch[:only_store].nil?
    srch[:show_box] = Setting.by_user(User.current.id).by_name('search.show_box').first.try(:value) if srch[:show_box].nil?
    requ[:only_available] = Setting.by_user(User.current.id).by_name('search.only_available').first.try(:value) if srch[:only_available].nil?
    requ[:only_store] = Setting.by_user(User.current.id).by_name('search.only_store').first.try(:value) if srch[:only_store].nil?
   end
   @search = OpenStruct.new(srch)
   @request = OpenStruct.new(requ)
  end

  def unmodify
   response.headers['Last-Modified'] = Time.zone.now.httpdate
  end

end
