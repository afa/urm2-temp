class UsersController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
   @user = User.create(params[:user])
   if @user.valid?
    flash[:info] = "ok"
   else
    flash[:error] = "fail"
    render :new
   end
  end

  def update
  end

  def destroy
  end

end
