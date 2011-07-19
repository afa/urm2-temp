class PasswordsController < ApplicationController
  def new
  end

  def index
  end

  def create
   if current_user.authenticated?(params[:user][:password])
    current_user.password = current_user.send(:calc_pass)
    @password = current_user.password
    current_user.save!
   else
    render :new
   end
  end

  def edit
  end

  def update
  end

end
