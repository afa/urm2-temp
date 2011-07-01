class Admin::SessionsController < Admin::ApplicationController
 skip_before_filter :authenticate!, :only => [:new, :create]

  def new
  end

  def create
   
  end

  def destroy
  end

end
