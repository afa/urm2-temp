class Admin::ManagersController < Admin::ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
   if Manager.create(params[:manager])
    redirect_to admin_managers_path
   else
    render :action => :new
   end
  end

  def edit
  end

  def update
  end

end
