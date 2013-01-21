class Admin::StatController < ApplicationController
  def index
   @events = Stat::Event.order("created_at desc").limit(1000)
  end

  def show
   @events = Stat::Event.where(:key => Stat::Event.find(params[:id]).try(:key)).order("created_at desc")
  end

end
