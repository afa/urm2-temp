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
   @quotation_info = Axapta.quotation_info(:quotation_id => params[:id]).first
   @quotation = Axapta.quotation_lines_paged(@page, :quotation_id => params[:id])#, :only_open => true)
  end

  def export_list
   respond_with do |format|
    format.csv do
     send_data CartItem.export(:csv, :quotations, Axapta.quotation_info_all(@filter_hash).items), :type => "application/csv", :disposition => :attachment
    end
   end
  end

  def cancelation
   
  end

  def save
   id = params[:id]
   lines = params.try(:[], :quotation).try(:[], id).try(:[], :line) || []
   if lines.empty?
    redirect_to quotation_path(id), :flash => {:error => "empty lines"}
    return
   end
   comment = params[:quotation][id][:comment]
   #@order = Axapta.sales_info(:sales_id => id.to_i)
   #@lines = Axapta.sales_lines(:sales_id => id.to_i)
   Axapta.quotation_handle_header(:comment => comment, :quotation_id => id)
   Axapta.quotation_handle_edit(:quotation_lines => lines.map{|k, v| v.merge(:line_id => k).merge(:requirements => v[:requirement]) }, :quotation_id => id) #TODO fix line_id for line_id
   redirect_to quotation_path(id)
  end

 protected
  def get_filter
   @filter = OpenStruct.new()
   @filter_hash = (params[:filter] || {}).merge(:quotation_statuses => YAML.load(Setting.find_by_name("hash.quotation_status").try(:value)).zip(YAML.load(Setting.find_by_name("hash.quotation_status_rus").try(:value))))
   @filter = OpenStruct.new(@filter_hash)
   @page = params[:page] || 1
   
  end

end
