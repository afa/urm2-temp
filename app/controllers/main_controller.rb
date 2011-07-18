class MainController < ApplicationController
 before_filter :get_users
  def index
  end

 protected
  def get_users
   @users = User.all
  end
end
