require "ostruct"
class MainController < ApplicationController
 before_filter :get_hash, :only => [:search, :extended]
 before_filter :get_users, :only => [:index]
  def index
  end

  def search
   @search = OpenStruct.new(params[:search]) if params[:search]
   @items = Axapta.search_names(params[:search].merge(:user_hash => @user_hash))
   @accounts = current_user.accounts
   @extended = OpenStruct.new(params[:extended])
  end

  def extended

  end
 protected
  def get_hash
   @user_hash = params[:hash]
  end

  def get_users
   @users = User.all
  end
end
