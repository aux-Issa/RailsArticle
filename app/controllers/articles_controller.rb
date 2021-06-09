class ArticlesController < ApplicationController
before_action :authenticate_user!, only:[:new, :edit, :create, :destroy]#deviseのヘルパーメソッド
before_action :ConfirmIfYouHaveRight, only:[:edit,:destroy]

    def new
        @article = Article.new
    end   
    def show
        @article = Article.find(params[:id])
        #redisにPVを保存
        #REDIS.zincrby "articles/daily/#{Date.today.to_s}", 1, @article.id
        #ids_scores = REDIS.zrevrangebyscore "articles/daily/#{Date.today.to_s}", "+inf", 0, :limit => [0, 3], :with_scores => true
        
        REDIS.zincrby "articles/PV", 1, @article.id
        ids_scores = REDIS.zrevrangebyscore "articles/PV", "+inf", 0, :limit => [0, 3], :with_scores => true
        @ids=[]
        scores=[]       
        ids_scores.each do |id, score|
          @ids << id
          scores << score.to_i
        end  
        best_articles = @ids.map{ |id| Article.find(id) }
        best_articles_titles=[]        
        best_articles.each do |best_article|        
          best_articles_titles << best_article.title
        end  
        @best_articles_titles_with_scores = best_articles_titles + scores
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
        flash[:notice] = "削除されました"
        REDIS.zrem "articles/PV", params[:id]
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
