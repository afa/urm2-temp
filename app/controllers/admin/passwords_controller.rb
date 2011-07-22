class Admin::PasswordsController < Admin::ApplicationController
 before_filter :get_user

  def index
  end

  def edit
  end

  def update
   if params[:password] and params[:password][:confirmed]
    @user.password = @user.calc_pass
    @user.save!
   else
    redirect_to admin_user_passwords_path(@user)
   end
  end

 protected
  def get_user
   @user = User.find(params[:user_id])
  end
end
