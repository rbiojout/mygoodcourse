class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_customer!, except: [:index, :show]

  before_action :correct_user, only: [:new, :create, :edit, :update, :destroy]
  # GET /posts
  # GET /posts.json
  def index
    #@posts = Post.where(status: POST::STATE_ACCEPTED).unscope(:order).order(created_at: :desc).all.paginate(page: params[:page], :per_page => 2)
    @posts = Post.all.unscope(:order).order(created_at: :desc).all.paginate(page: params[:page], :per_page => 2)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    # follow activity on pages
    # we keep track of the current customer in impressions
    @current_user = current_customer
    impressionist(@post)
    @top_posts = Post.where.not(id: @post.id).order(counter_cache: :desc).limit(10)
  end

  # GET /posts/new
  def new
    @post = current_customer.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        @post.accept!
        format.html { redirect_to @post, notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        @post.cancel!
        format.html { redirect_to @post, notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.friendly.find(params[:id])
    end

  def correct_user
    redirect_to posts_path, alert: t('dialog.restricted') unless @post.nil? || @post.customer_id == current_customer.id
  end


  # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:name, :description, :visual, :visual_cache, :customer_id)
    end
end
