class ArticlesController < ApplicationController
  before_action :set_country, only: [:index]
  before_action :set_topic, only: [:index, :show, :new, :edit, :update]
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_employee!, except: [:index, :show]


  # GET /articles
  # GET /articles.json
  def index
    @topics = @country.topics
    @articles = @topic.articles
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    # increment the number of visits if visit don't come from edit/update
    unless (request.referrer == edit_topic_article_url(@article, :topic_id => @article.topic_id))
      visits = @article.visits || 0
      @article.visits = visits + 1
      @article.save
    end
  end

  # GET /articles/new
  def new
    @article = @topic.articles.build
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to topic_article_path(@article, :topic_id => @article.topic_id), notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to topic_article_path(@article, :topic_id => @article.topic_id), notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to topic_articles_url(:topic_id => @article.topic_id), notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /articles/sort
  def sort
    logger.debug("===> params[:article] #{params[:article]}")
    unless params[:article].nil?
      params[:article].each .each_with_index do |id, index|
        Article.update(id, position: index+1)
        logger.debug("===> id #{id} index #{index}")
      end
    end
    render nothing:true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.friendly.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.friendly.find(params[:topic_id]) unless params[:topic_id].nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:name, :description, :position, :topic_id)
    end

    # We need to have a filter when listing the articles.
    def set_country
      # we need the country
      # Look for the Country from the request or from the session cookie
      country_id = params[:country_id] || session[:country_store]

      # validate if the Country exist
      @country = Country.first
      begin
        @country = Country.find(country_id) unless country_id.nil?
      rescue ActiveRecord::RecordNotFound
        logger.error("Unable to find country #{country_id}")
      end
      @topic = @country.topics.first

      # change the topic if the country is changing
      params[:topic_id] = @topic.id unless session[:country_store] == @country.id

      session[:country_store] = @country.id
    end

end
