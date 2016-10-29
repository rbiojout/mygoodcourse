class AbusesController < ApplicationController
  before_action :context, only: [:new, :create]
  before_action :authenticate_customer!


  # GET /abuses/1
  # GET /abuses/1.json
  def show
  end

  # GET /abuses/new
  def new
    @context = context
    @abuse = @context.abuses.build
  end

  # GET /abuses/1/edit
  def edit
    @context = context
  end

  # POST /abuses
  # POST /abuses.json
  def create
    @context = context
    @abuse = @context.abuses.new(abuse_params)
    # we set the current customer
    @abuse.customer = current_customer

    respond_to do |format|
      if @abuse.save
        # tell the state engine
        # need the bang! to save in database
        @abuse.receive!
        # display the new abuse
        format.html { redirect_to context_url(context), notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @abuse }
        # added
        format.js   {
          @current_abuse = @abuse
          render :create, :flash => { :notice => "Yeepee!" }
        }
      else
        format.html { render :new }
        format.json { render json: @abuse.errors, status: :unprocessable_entity }
        # added
        # needed for errors, cf abuse.coffee
        format.js   { render json: @abuse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /abuses/1
  # PATCH/PUT /abuses/1.json
  def update
    @context = context
    respond_to do |format|
      if @abuse.update(abuse_params)
        format.html { redirect_to context_url(context), notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @abuse }
      else
        format.html { render :edit }
        format.json { render json: @abuse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /abuses/1
  # DELETE /abuses/1.json
  def destroy
    @abuse.destroy
    respond_to do |format|
      format.html { redirect_to abuses_url(), notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_abuse
    @abuse = Abuse.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def abuse_params
    params.require(:abuse).permit(:description, :customer_id)
  end

  # as a polymorphic object, we need the context
  def context
    if params[:product_id]
      id = params[:product_id]
      Product.find(params[:product_id])
    elsif params[:review_id]
      id = params[:review_id]
      Review.find(params[:review_id])
    elsif params[:comment_id]
      id = params[:comment_id]
      Comment.find(params[:comment_id])
    end
  end

  def context_url(context)
    if Product === context
      product_path(context)
    elsif Review === context
      review_path(context)
    elsif Comment === context
      comment_path(context)
    end
  end


end
