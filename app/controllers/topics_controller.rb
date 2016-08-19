class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :set_country, only: [:index]

  # GET /topics
  # GET /topics.json
  def index
    @topics = @country.topics
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
  end

  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /topics/sort
  def sort
    unless params[:topic].nil?
      params[:topic].each .each_with_index do |id, index|
        Topic.update(id, position: index+1)
      end
    end
    render nothing:true
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:name, :description, :position, :country_id)
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

      end

      session[:country_store] = @country.id
    end
end
