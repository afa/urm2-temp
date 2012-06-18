class Admin::HelpArticleController < Admin::ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def update
   redirect_to admin_help_article_path(params[:id])
  end

  def new
  end

  def create
   redirect_to admin_help_article_index_path
  end

end
