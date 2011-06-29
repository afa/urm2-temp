class SessionsController < ApplicationController
  def new
  end

  def create
   if @current_user = User.authenticate(params["session"]["username"], params["session"]["password"])
    session[:user] = @current_user.id
   end
   redirect_to root_path
  end

  def destroy
   session[:user] = nil
   redirect_to root_path
  end

end
