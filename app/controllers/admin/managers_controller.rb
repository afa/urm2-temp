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

    def sign_in(user)
      if user
        cookies[:remember_token] = {
          :value   => user.remember_token,
          :expires => 1.year.from_now.utc
        }
        self.current_user = user
      end
    end

    def sign_out
      current_user.reset_remember_token! if current_user
      cookies.delete(:remember_token)
      self.current_user = nil
    end

    protected

    def user_from_cookie
      if token = cookies[:manager_remember_token]
        Manager.find_by_remember_token(token)
      end
    end



end
