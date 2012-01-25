class Admin::NewsController < Admin::ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
   NewsArticle.create params[:news_article]
   redirect_to :admin_root_path
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
