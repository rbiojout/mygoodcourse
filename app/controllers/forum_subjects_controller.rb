class ForumSubjectsController < ApplicationController
  before_action :set_forum_subject, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_customer!, except: [:index, :show]

  before_action :set_forum_category, only: [:new]

  before_action :correct_user, only: [:new, :create, :edit, :update, :destroy]

  # GET /forum_subjects
  # GET /forum_subjects.json
  def index
    @forum_subjects = ForumSubject.all
  end

  # GET /forum_subjects/1
  # GET /forum_subjects/1.json
  def show
    # follow activity on pages
    # we keep track of the current customer in impressions
    @current_user = current_customer
    impressionist(@forum_subject)

    @forum_answers = @forum_subject.forum_answers.paginate(page: params[:page], per_page: PAGINATE_PAGES)

    @top_forum_subjects = ForumSubject.where.not(id: @forum_subject.id).order(counter_cache: :desc).limit(10)
  end

  # GET /forum_subjects/new
  def new
    @forum_subject = @forum_category.forum_subjects.new
    @forum_subject.customer = current_customer
  end

  # GET /forum_subjects/1/edit
  def edit; end

  # POST /forum_subjects
  # POST /forum_subjects.json
  def create
    @forum_subject = ForumSubject.new(forum_subject_params)

    respond_to do |format|
      if @forum_subject.save
        format.html { redirect_to forum_category_path(@forum_subject.forum_category), notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @forum_subject }
      else
        format.html { render :new }
        format.json { render json: @forum_subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # close the form
  # GET /forum_subjects/1/undo
  def undo
    @forum_subject = ForumSubject.find(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    @forum_subject = nil
  end

  # PATCH/PUT /forum_subjects/1
  # PATCH/PUT /forum_subjects/1.json
  def update
    respond_to do |format|
      if @forum_subject.update(forum_subject_params)
        format.html { redirect_to @forum_subject, notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @forum_subject }
        # added
        format.js   { @current_forum_subject = @forum_subject }
      else
        format.html { render :edit }
        format.json { render json: @forum_subject.errors, status: :unprocessable_entity }
        # added
        format.js   { render json: @forum_subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_subjects/1
  # DELETE /forum_subjects/1.json
  def destroy
    @forum_subject.destroy
    respond_to do |format|
      format.html { redirect_to forum_subjects_url, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_forum_subject
    @forum_subject = ForumSubject.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_forum_category
    @forum_category = ForumCategory.find_by(id: params[:forum_category_id]) unless params[:forum_category_id].nil?
    redirect_to forum_families_path, alert: t('dialog.restricted') if @forum_category.nil?
  end

  def correct_user
    redirect_to forum_families_path, alert: t('dialog.restricted') unless @forum_subject.nil? || @forum_subject.customer_id == current_customer.id
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def forum_subject_params
    params.require(:forum_subject).permit(:name, :text, :customer_id, :forum_category_id)
  end
end
