class Admin::ApplicationController < ActionController::Base
  include Afauth::Controller::App
  remembered_cookie_name :manager_remember_token
  user_model Manager
  auth_expired_in_days 1.year
  redirect_failed_cb :cb_failed
  before_logout_cb :cb_before_logout
  post_logout_cb :cb_post_logout
  authen_field_name :name
  post_sign_cb :cb_logged
  layout "admin/application"
  helper Admin::ApplicationHelper
  protect_from_forgery
  def cb_failed
   new_admin_session_path
  end

  def cb_before_logout
   Manager.current.reset_remember_token!
  end

 protected
  def cb_logged
   redirect_to admin_root_path
  end

  def cb_post_logout
   redirect_to admin_root_path
  end
end
