class HomeController < ApplicationController
  def index
    @articles = Article.all
    #ids_scores = REDIS.zrevrangebyscore "articles/daily/#{Date.today.to_s}", "+inf", 0, :limit => [0, 3], :with_scores => true
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

  def show
  end
end
