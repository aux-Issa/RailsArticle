class ArticlesController < ApplicationController
before_action :ConfirmIfYouHaveRight, only:[:edit,:destroy]
before_action :authenticate_user!, only:[:new, :edit, :create, :destroy]#deviseのヘルパーメソッド

    def new
        @article = Article.new
    end   
    def show
        @article = Article.find(params[:id])
    end
    def create
        @article = current_user.articles.build(articles_params)
        if @article.save
          flash[:notice] = "記事が投稿されました"
          redirect_to root_url
        else 
          render new_article_path
          flash[:alert] = "無効な投稿です"
          
        end          
    end
    
    def edit
        
    end   
    
    def update
        @article = Article.find(params[:id])
        if @article.update(articles_params)
          redirect_to root_url
          flash[:notice]="投稿を更新しました"
        else
          redirect_to request.referer
          flash[:alert]="無効な投稿です"
        end
    end    
        
        
    def destroy
        @article.destroy 
        flash.now[:success] = "削除されました"
        redirect_to  root_url
    end
    
  private
    def articles_params
      params.require(:article).permit(:title, :content)
    end     
    def ConfirmIfYouHaveRight
        @article = Article.find(params[:id])
        unless current_user.id == @article.user_id
            redirect_to root_url
            flash[:notice]= "権限がありません"
        end    
    end    
    
end
