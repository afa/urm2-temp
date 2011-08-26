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
   
   logger.info "--- request_start: #{Time.now}"
   begin
    data = Axapta.search_names({:calc_price=>true, :calc_qty => true}.merge(params[:search] || {}).merge(:user_hash => current_user.current_account.try(:axapta_hash)))
   rescue Exception => e
    p e
    logger.info e.to_s
   end
   logger.info "--- request_hash: #{data.inspect}"
   logger.info "--- request_acc: #{current_user.current_account.id}"
   @items = data.inject([]) do |r, i|
    i["locations"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_in_pack" => i["qty_in_pack"], "location_id" => loc["location_id"], "min_qty" => i["min_qty"], "max_qty" => loc["vend_qty"]}
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
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
   @items = Axapta.search_dms_names(:user_hash => @hash, :query_string => @seek, :search_brend => @brend).inject([]) do |r, i|
    p i
    i["prognosis"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_in_pack" => loc["qty_multiplies"], "max_qty" => loc["vend_qty"]}#, "min_qty" => i["min_qty"], "location_id" => loc["location_id"]
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
     r << a
    end
    r
   end
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
