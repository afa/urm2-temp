require "ostruct"
class MainController < ApplicationController

 respond_to :js, :html

 before_filter :get_users, :only => [:index]
 before_filter :get_accounts, :only => [:index, :search, :extended]
 before_filter :check_account, :only => [:search, :extended, :dms]
  def index
  end

  def search
   @search = OpenStruct.new(params[:search]) if params[:search]
   
   @items = Axapta.search_names({:calc_price=>true, :calc_qty => true}.merge(params[:search] || {}).merge(:user_hash => current_user.current_account.try(:axapta_hash))).inject([]) do |r, i|
    i["locations"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_in_pack" => i["qty_in_pack"], "location_id" => loc["location_id"]}
     r << a
    end
    r
   end
   #@accounts = current_user.accounts
   @extended = OpenStruct.new({:calc_price=>true, :calc_qty => true}.merge(params[:extended] || {}))
  end

  def dms
   @after = params[:after]
   @seek = params[:name]
   @brend = params[:brend]
   @hash = current_user.current_account.try(:axapta_hash)
   @items = Axapta.search_dms_names(:user_hash => @hash, :query_string => @seek, :search_brend => @brend)
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
  def get_users
   @users = User.all
  end

  def get_accounts
   @accounts = current_user.accounts.where(:blocked => false)
  end

  def check_account
   if current_user.current_account
    if current_user.current_account.blocked?
     redirect_to root_path
    end
   else
    redirect_to root_path
   end
  end
end
