require "ostruct"
class MainController < ApplicationController

 respond_to :js, :html

 before_filter :get_hash, :only => [:search, :extended, :index]
 before_filter :get_users, :only => [:index]
 before_filter :get_accounts, :only => [:index, :search, :extended]
  def index
  end

  def search
   @search = OpenStruct.new(params[:search]) if params[:search]
   
   @items = Axapta.search_names({:calc_price=>true, :calc_qty => true}.merge(params[:search] || {})) #.merge(:user_hash => @user_hash))
   #@accounts = current_user.accounts
   @extended = OpenStruct.new({:calc_price=>true, :calc_qty => true}.merge(params[:extended] || {}))
  end

  def dms
   @seek = params[:name]
   @hash = Account.find(params[:acc]).try(:axapta_hash)
   @items = Axapta.search_dms_names(:user_hash => @hash, :query_string => @seek)
   respond_with do |format|
    format.js { render :layout => false } #do
    # render(:update) {|page| page.replace_html 'div.tst', '<div>asd</div>'.html_safe }
    #end
    format.html do
     redirect_to root_path
    end
   end
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

  def get_accounts
   @accounts = current_user.accounts.where(:blocked => false)
  end
end
