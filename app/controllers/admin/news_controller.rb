class Admin::NewsController < Admin::ApplicationController
 before_filter :get_article, :only => [:show, :edit, :update, :destroy]
 before_filter :new_article, :only => [:new]
  def index
  end

  def show
  end

  def new
  end

  def create
   NewsArticle.create(params[:news_article].merge(:last_editor_id => Manager.current.id))
   redirect_to admin_root_path
  end

  def edit
  end

  def update
   @news_article.update_attributes(params[:news_article].merge(:last_editor_id => Manager.current.id))
   redirect_to admin_root_path
  end

  def destroy
  end

 protected
  def get_article
   @news_article = NewsArticle.find(params[:id])
  end
  def new_article
   @news_article = NewsArticle.new
  end
end
