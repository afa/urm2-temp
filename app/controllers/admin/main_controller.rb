class Admin::MainController < Admin::ApplicationController
  def index
   @users = User.all
   @news = NewsArticle.order("created_at desc").all
  end

end
