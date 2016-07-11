class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_customer!, only: [:new, :create, :update, :edit, :destroy]


  before_action :correct_user, except: :show

  # GET /comments
  # GET /comments.json
  def index
    if (params[:product_id].nil?)
      @comments = Comment.all
    else
      @comments.product = Product.find(params[:product_id])
    end
    @comments = @comments.paginate(page: params[:page], :per_page => PAGINATE_PAGES)
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    @comment.customer = current_customer
    @comment.product = Product.find(params[:product_id]) unless params[:product_id].nil?
  end


  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.customer = current_customer
    @nb_comments = @comment.product.nb_comments

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: t('views.flash_create_message') }
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
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: t('views.flash_update_message') }
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
      params.require(:comment).permit(:title, :description, :score, :product_id)
    end

  def correct_user
    redirect_to catalog_products_path, alert: t('dialog.restricted') unless @comment.nil? || @comment.product.customer_id == current_customer.id
  end

end
