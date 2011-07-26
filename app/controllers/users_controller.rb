class UsersController < ApplicationController
 skip_filter :authenticate!, :only => [:new, :create]
  def index
   @children = current_user.axapta_children
   @parent = current_user.parent
  end

  def show
  end

  def new
   @user = User.new
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
