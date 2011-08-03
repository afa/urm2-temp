require "ostruct"
class MainController < ApplicationController
 before_filter :get_users, :only => [:index]
  def index
  end

  def search
   @search = OpenStruct.new(params[:search]) if params[:search]
   @items = []
  end
 protected
  def get_users
   @users = User.all
  end
end
