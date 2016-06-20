class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:show, :edit, :update, :destroy, :download]
  before_action :authenticate_customer!, only: [:sort, :download]

  # GET /attachments
  # GET /attachments.json
  def index
    @attachments = Attachment.all
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
  end

  # GET /attachments/new
  def new
    @attachment = Attachment.new
  end

  # GET /attachments/1/edit
  def edit
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = Attachment.new(attachment_params)
    logger.debug("params #{params[:product_id]}  #{params[:attachment][:product_id]}")
    @product = Product.find(params[:attachment][:product_id])

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @attachment }
      else
        format.html { render :new }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment, notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @attachment }
      else
        format.html { render :edit }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to attachments_url, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

  # GET /attachments/1
  def download
    @pdf = @attachment.file.file.file
    respond_to do |format|
      format.pdf do
        send_file(@pdf, filename: 'my-awesome-pdf.pdf', type: 'application/pdf', disposition: 'inline')
      end
    end
  end

  # POST /attachments/sort
  def sort
    unless params[:attachment].nil?
      params[:attachment].each .each_with_index do |id, index|
        Attachment.update(id, position: index+1)
      end
    end
    render nothing:true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:file, :file_cache, :file_size, :file_type, :nbpages, :version_number, :active, :product_id)
    end
end
