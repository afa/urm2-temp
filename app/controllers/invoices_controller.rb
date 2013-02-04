class InvoicesController < ApplicationController
  def index
  end

  def show
   @invoice = Axapta.sales_report_all(:invoice_id => params[:id])
   @invoice.id = params[:id]
  end

  def archive
  end
end
