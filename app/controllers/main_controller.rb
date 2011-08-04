require "ostruct"
class MainController < ApplicationController
 before_filter :get_users, :only => [:index]
  def index
  end

  def search
   @search = OpenStruct.new(params[:search]) if params[:search]
   @items = []
   @accounts = current_user.accounts
   @extended = OpenStruct.new(params[:extended])
  end
 protected
  def get_users
   @users = User.all
  end
end
