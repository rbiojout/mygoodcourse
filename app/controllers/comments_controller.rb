class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_customer!, excep: [:index, :show]

  before_action :correct_user, excep: [:index, :show]

  before_action :context, only: [:like, :unlike]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all.paginate(page: params[:page], :per_page => PAGINATE_PAGES)
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @context = context
    @comment = @context.comments.build
  end

  # GET /comments/1/edit
  def edit
    @context = context
  end

  # POST /comments
  # POST /comments.json
  def create
    @context = context
    @comment = @context.comments.new(comment_params)
    # we set the current customer
    @comment.customer = current_customer

    respond_to do |format|
      if @comment.save
        format.html { redirect_to context_url(context), notice: t('views.flash_update_message') }
        format.json { render :show, status: :created, location: @comment }
        # added
        format.js   { @current_comment = @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        # added
        format.js   { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @context = context
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to context_url(context), notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @comment }
        # added
        format.js   { @current_comment = @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        # added
        format.js   { @current_comment = @comment }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:text, :customer_id, :commentable_id)
    end

  def correct_user
    redirect_to catalog_products_path, alert: t('dialog.restricted') unless @comment.nil? || @comment.customer_id == current_customer.id
  end

  # as a polymorphic object, we need the context
  def context
    if params[:post_id]
      id = params[:post_id]
      Post.find(params[:post_id])
    end
  end

  def context_url(context)
    if Post === context
      post_path(context)
    end
  end

end
