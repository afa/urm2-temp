require "ostruct"
class MainController < ApplicationController

 respond_to :js, :html

 #before_filter :get_users, :only => [:index]
 before_filter :get_accounts, :only => [:index, :search, :extended]
 before_filter :check_account, :only => [:search, :extended, :dms]
  def index
  end

  def search
   #@search = OpenStruct.new(params[:search]) if params[:search]
   
   logger.info "--- request_start: #{Time.now}"
   @only_store = params[:search].try(:[], :only_store) || false
   stor = current_user.settings.where(:name => "search.only_store").first || current_user.settings.where(:name => "search.only_store").new
   stor.value = @only_store
   stor.save!
   @only_available = params[:search].try(:[], :only_available) || false
   avail = current_user.settings.where(:name => "search.only_available").first || current_user.settings.where(:name => "search.only_available").new
   avail.value = @only_available
   avail.save!
   begin
    data = Axapta.search_names({:calc_price=>true, :calc_qty => true}.merge(params[:search] || {}).merge(:user_hash => current_user.current_account.try(:axapta_hash)))
   rescue Exception => e
    p "---exc in search #{Time.now}", e
    logger.info e.to_s
   end
   @items = (data || []).inject([]) do |r, i|
    i["locations"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_in_pack" => i["qty_in_pack"], "location_id" => loc["location_id"], "min_qty" => i["min_qty"], "max_qty" => loc["vend_qty"], "rohs" => i["rohs"], "item_id" => i["item_id"], "segment_rus" => i["segment_rus"], "body_name" => i["package_name"]}
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
     r << a
    end
    r
   end
  end

  def dms
   @after = params[:after]
   @seek = params[:name]
   @code = params[:code]
   @brend = params[:brend]
   @hash = current_user.current_account.try(:axapta_hash)
   @items = Axapta.search_dms_names(:user_hash => @hash, :item_id_search => @code, :query_string => @seek, :search_brend => @brend).inject([]) do |r, i|
    i["prognosis"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_in_pack" => loc["qty_multiples"], "max_qty" => loc["vend_qty"], "rohs" => i["rohs"], "prognosis_id" => loc["prognosis_id"]}#, "min_qty" => i["min_qty"], "location_id" => loc["location_id"]
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"], "min_qty" => locs[0]["min_qty"], "vend_proposal_date" => locs[0]["vend_proposal_date"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
     a.merge!("need_more" => true) if loc["price_qty"].size > 4
     r << a
    end
    r
   end
   respond_with do |format|
    format.js { render :layout => false }
    format.html do
     redirect_to root_path
    end
   end
  end

  def analog
   @after = params[:after]
   @code = params[:code]
   @hash = current_user.current_account.try(:axapta_hash)
   
   logger.info "--- request_start: #{Time.now}"
   begin
    data = Axapta.search_analogs({:calc_price=>true, :calc_qty => true, :user_hash => @hash, :item_id_search => @code})
   rescue Exception => e
    p "---exc in search #{Time.now}", e
    logger.info e.to_s
   end
   @items = data.inject([]) do |r, i|
    i["locations"].each do |loc|
     a = {"item_name" => i["item_name"], "item_brend" => i["item_brend"], "qty_in_pack" => i["qty_in_pack"], "location_id" => loc["location_id"], "min_qty" => i["min_qty"], "max_qty" => loc["vend_qty"], "rohs" => i["rohs"], "item_id" => i["item_id"], "segment_rus" => i["segment_rus"], "package_name" => i["package_name"]}
     locs = loc["price_qty"].sort_by{|l| l["min_qty"] }[0, 4]
     a.merge!("price1" => locs[0]["price"]) if locs[0]
     a.merge!("price2" => locs[1]["price"], "count2" => locs[1]["min_qty"]) if locs[1]
     a.merge!("price3" => locs[2]["price"], "count3" => locs[2]["min_qty"]) if locs[2]
     a.merge!("price4" => locs[3]["price"], "count4" => locs[3]["min_qty"]) if locs[3]
     r << a
    end
    r
   end
  end

 protected
  def get_accounts
   @accounts = current_user.accounts.where(:blocked => false)
  end

  def check_account
   if current_user.current_account
    if current_user.current_account.blocked? or current_user.accounts.where(:id => current_user.current_account_id).count == 0
     redirect_to root_path
    end
   else
    redirect_to root_path
   end
  end
end
