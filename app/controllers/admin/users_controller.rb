class Admin::UsersController < Admin::ApplicationController
 before_filter :get_user, :except => [:index]

  def index
   @users = User.all
  end

  def show
  end

  def edit
  end

  def update
   if @user.update_attributes params[:user]
    redirect_to admin_users_path
   else
    render :edit
   end
  end

 protected
  def get_user
   @user = User.find(params[:id])
  end
end
