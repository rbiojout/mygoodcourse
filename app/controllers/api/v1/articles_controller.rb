class Api::V1::ArticlesController < API::ApplicationController

  before_action :set_topic, only: [:index, :show, :new, :create, :edit, :update]
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_employee!, except: [:index, :show, :search, :top]

  # GET /:locale/topics/:topic_id/articles(.:format)
  def index
    @topics = current_country.topics
    @articles = @topic.articles

    render json: @articles, each_serializer: ArticleSerializer
  end


  # GET /:locale/topics/top(.:format)
  def top
    @articles = Article.top_for_country(current_country.id)

    render json: @articles, each_serializer: ArticleSerializer
  end


  # POST /:locale/articles/search(.:format)
  def search
    @topics = current_country.topics
    @topic = @topics.first
    # retrieve the search query
    # filter only on active products when searching
    query = params[:query]

    query_articles_store = session[:query_articles_store]

    unless query.nil?
      # we add or remove if the parameter is sent
      query_articles_store = if query.empty?
                               nil
                             else
                               query
                             end
    end

    session[:query_articles_store] = query_articles_store
    @articles = Article.search_by_text(query_articles_store).joins(:topic).where(topics: {country_id: current_country})

  end

  # GET /:locale/topics/:topic_id/articles/:id(.:format)
  def show
    # follow activity on pages
    # we keep track of the current customer in impressions
    @current_user = current_customer
    impressionist(@article)
    # need to reload object
    @article = @article.reload
  end

  # GET /:locale/topics/:topic_id/articles/new(.:format)
  def new
    @article = @topic.articles.build
  end

  # GET /:locale/topics/:topic_id/articles/:id/edit(.:format)
  def edit; end

  # POST /:locale/topics/:topic_id/articles(.:format)
  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
        format.html { redirect_to topic_article_path(@article, topic_id: @article.topic_id), notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /:locale/topics/:topic_id/articles/:id(.:format)
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to topic_article_path(@article, topic_id: @article.topic_id), notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /:locale/topics/:topic_id/articles/:id(.:format)
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to topic_articles_url(topic_id: @article.topic_id), notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

  # POST /:locale/articles/sort(.:format)
  def sort
    unless params[:article].nil?
      params[:article].each .each_with_index do |id, index|
        Article.update(id, position: index + 1)
      end
    end
    head :ok
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
end
