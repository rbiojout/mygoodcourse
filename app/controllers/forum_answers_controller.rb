class ForumAnswersController < ApplicationController
  before_action :set_forum_answer, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_customer!, except: [:index, :show]

  before_action :set_forum_subject, only: [:new]

  before_action :correct_user, only: [:new, :create, :edit, :update, :destroy]

  # GET /forum_answers
  # GET /forum_answers.json
  def index
    @forum_answers = ForumAnswer.all
  end

  # GET /forum_answers/1
  # GET /forum_answers/1.json
  def show; end

  # GET /forum_answers/new
  def new
    @forum_answer = @forum_subject.forum_answers.new
    @forum_answer.customer = current_customer
  end

  # GET /forum_answers/1/edit
  def edit; end

  # POST /forum_answers
  # POST /forum_answers.json
  def create
    @forum_answer = ForumAnswer.new(forum_answer_params)

    respond_to do |format|
      if @forum_answer.save
        format.html { redirect_to forum_subject_path(@forum_answer.forum_subject), notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @forum_answer }
        # added
        format.js   { @current_forum_answer = @forum_answer }
      else
        logger.debug('error processing')
        format.html { render :new }
        format.json { render json: @forum_answer.errors, status: :unprocessable_entity }
        # added
        format.js   { render json: @forum_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # close the form
  # GET /forum_answers/1/undo
  def undo
    @forum_answer = ForumAnswer.find(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    @forum_answer = nil
  end


  # PATCH/PUT /forum_answers/1
  # PATCH/PUT /forum_answers/1.json
  def update
    respond_to do |format|
      if @forum_answer.update(forum_answer_params)
        format.html { redirect_to @forum_answer, notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @forum_answer }
        # added
        format.js   { @current_forum_answer = @forum_answer }
      else
        format.html { render :edit }
        format.json { render json: @forum_answer.errors, status: :unprocessable_entity }
        # added
        format.js   { render json: @forum_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_answers/1
  # DELETE /forum_answers/1.json
  def destroy
    forum_subject = @forum_answer.forum_subject
    @forum_answer.destroy
    respond_to do |format|
      format.html { redirect_to forum_subject_path(forum_subject), notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_forum_answer
    @forum_answer = ForumAnswer.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_forum_subject
    @forum_subject = ForumSubject.find_by(id: params[:forum_subject_id]) unless params[:forum_subject_id].nil?
    redirect_to forum_families_path, alert: t('dialog.restricted') if @forum_subject.nil?
  end

  def correct_user
    redirect_to forum_families_path, alert: t('dialog.restricted') unless @forum_answer.nil? || @forum_answer.customer_id == current_customer.id
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def forum_answer_params
    params.require(:forum_answer).permit(:text, :customer_id, :forum_subject_id)
  end
end
