class LikesController < ApplicationController
  before_action :context, only: [:like, :unlike]
  before_action :authenticate_customer!

  # POST /like/like?context_id=
  def like
    @context = context
    @like = @context.likes.new
    # we set the current customer
    @like.customer = current_customer

    respond_to do |format|
      if @like.save
        format.html { redirect_back(fallback_location: root_path, notice: 'Like was successfully created.')  }
        format.json { render :show, status: :created, location: @like }
        format.js { render :like }
      else
        # format.html { render :new }
        format.json { render json: @like.errors, status: :unprocessable_entity }
        format.js   { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/unlike?context_id=
  def unlike
    @context = context
    Like.for_customer_likeable(current_customer, @context).destroy_all
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: 'Like was successfully destroyed.') }
      format.json { head :no_content }
      format.js { render :unlike}
    end
  end

private

  # as a polymorphic object, we need the context
  # param is constructed from the Class name to lower case
  def context
    if params[:product_id]
      Product.find(params[:product_id])
    elsif params[:post_id]
      Post.find(params[:post_id])
    elsif params[:review_id]
      Review.find(params[:review_id])
    elsif params[:forum_subject_id]
      ForumSubject.find(params[:forum_subject_id])
    end
  end

  def context_url(context)
    if context.is_a?(Product)
      product_path(context)
    elsif context.is_a?(post)
      post_path(context)
    elsif context.is_a?(Review)
      review_path(context)
    elsif context.is_a?(ForumSubject)
      review_path(context)
    end
  end
end
