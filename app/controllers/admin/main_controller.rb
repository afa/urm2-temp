class Admin::MainController < Admin::ApplicationController
  def index
   @users = User.all
  end

end
