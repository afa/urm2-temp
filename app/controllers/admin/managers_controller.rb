class Admin::ManagersController < Admin::ApplicationController

 before_filter :take_manager, :only => [:show, :edit, :update]
  def index
   @managers = Manager.all
  end

  def show
  end

  def new
  end

  def create
   if current_user.super && Manager.create(params[:manager])
    redirect_to admin_managers_path
   else
    render :template => "admin/managers/new"
   end
  end

  def edit
  end

  def update
   if (current_user.super || current_user == @manager) && @manager.update_attributes(params[:manager])
    redirect_to admin_managers_path
   else
    render :template => "admin/managers/edit"
   end
  end

 protected
  def take_manager
   @manager = Manager.find(params[:id])
  end
end
