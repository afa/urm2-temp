class QuotationsController < ApplicationController

 respond_to :html, :js
 before_filter :get_filter

  def index
   hsh = params[:filter] || {} 
   @quotations = Axapta.quotation_info_paged(@page, {:order_quotation_id => "desc"}.merge(hsh))
  end

  def lines
   hsh = params[:filter] || {}
   @lines = Axapta.quotation_lines_paged(@page, {:order_quotation_id => "desc"}.merge(hsh))
  end

  def show
   @quotation = Axapta.quotation_lines_paged(@page, :quotation_id => params[:id])#, :only_open => true)
  end


 protected
  def get_filter
   @filter = OpenStruct.new()
   @filter_hash = (params[:filter] || {}).merge(:quotation_statuses => YAML.load(Setting.find_by_name("hash.quotation_status").try(:value)).zip(YAML.load(Setting.find_by_name("hash.quotation_status_rus").try(:value))))
   @filter = OpenStruct.new(@filter_hash)
   @page = params[:page] || 1
   
  end

end
