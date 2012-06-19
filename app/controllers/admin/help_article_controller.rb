class Admin::HelpArticleController < Admin::ApplicationController

 before_filter :get_articles, :only => [:index]
 before_filter :get_article, :only => [:show, :edit, :update, :destroy]
  def index
   @articles = HelpArticle.order('name asc').all
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
   if @article = HelpArticle.create(params[:article])
    redirect_to admin_help_article_index_path
   else
    render :new
   end
  end

 protected

  def get_article
   @article = HelpArticle.find(params[:id])
  end
  def get_articles
   @articles = HelpArticle.order('name asc').all
  end
end
