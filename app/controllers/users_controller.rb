class UsersController < ApplicationController
 skip_filter :authenticate!, :only => [:new, :create]
 before_filter :get_user, :only => [:edit, :update, :show, :destroy]
 before_filter :check_user, :only => [:edit, :update, :show, :destroy]
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
   if @user.update_attributes params[:user]
    redirect_to users_path
   else
    flash.now[:error] = 'fail'
    render :edit
   end
  end

  def destroy
  end

 protected
  def get_user
   @user = User.find(params[:id])
  end

  def check_user
   redirect_to users_path, :flash => {:error => 'denied'} unless current_user == @user || current_user == @user.parent || @user.axapta_children.include?(current_user)
  end
end
