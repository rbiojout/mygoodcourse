class AttachmentsController < ApplicationController
  require 'open-uri'

  before_action :set_attachment, only: [:download]
  # before_action :authenticate_customer!, only: [:sort, :download]

  before_action :correct_user, only: [:download]

  # GET /attachments/1/download
  # no format needed in parameters for the response
  # file sent inline with the content-type founded
  def download
    # decryption
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.decrypt

    buf = ''
    enc_file = @attachment.file.file
    file_name = 'MyGoodCourse_' + @attachment.product.name + File.extname(enc_file.filename)
    file_type = 'application/pdf'

    outf = ''
    if enc_file.nil? == false
      if enc_file.is_a?(CarrierWave::SanitizedFile)
        file_type = MIME::Types.type_for(enc_file.file).first.content_type
        # if no encryption take only the file
        if @attachment.key.nil? || @attachment.key.blank?
          outf = File.read(enc_file.file)
        else
          cipher.key = @attachment.key
          cipher.iv = @attachment.iv # key and iv are the ones from above
          File.open(enc_file.file, 'rb') do |inf|
            outf << cipher.update(buf) while inf.read(4096, buf)
            outf << cipher.final
          end
        end

      elsif enc_file.is_a?(CarrierWave::Storage::Fog::File)
        file_type = enc_file.content_type
        if @attachment.key.nil? || @attachment.key.blank?
          outf = open(enc_file.url).read
        else
          cipher.key = @attachment.key
          cipher.iv = @attachment.iv # key and iv are the ones from above
          open(enc_file.url) do |inf|
            outf << cipher.update(buf) while inf.read(4096, buf)
            outf << cipher.final
          end
        end
      end
      # send the file
      send_data(outf, filename: file_name, type: file_type, disposition: :inline)
    end
  end

  # GET /attachments/1
  def download_old
    @pdf = @attachment.file.file
    if @pdf.nil? == false && @attachment.product.candownload(current_customer)
      if @pdf.is_a?(CarrierWave::SanitizedFile)
        respond_to do |format|
          format.pdf do
            send_file(@pdf.path, filename: 'MyGoodCourse.pdf', type: 'application/pdf', disposition: 'inline')
          end
        end
      elsif @pdf.is_a?(CarrierWave::Storage::Fog::File)
        respond_to do |format|
          data_pdf = open(@pdf.url).read
          format.pdf do
            send_data(data_pdf, filename: 'MyGoodCourse.pdf', type: 'application/pdf', disposition: 'inline')
          end
        end
      end

    end
  end

  # POST /attachments/sort
  def sort
    unless params[:attachment].nil?
      params[:attachment].each .each_with_index do |id, index|
        Attachment.update(id, position: index + 1)
      end
    end
    render nothing: true
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def correct_user
    redirect_to catalog_products_path(format: :html), alert: t('dialog.restricted') if current_customer.nil? || @attachment.nil? || !@attachment.product.candownload(current_customer)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attachment_params
    params.require(:attachment).permit(:file, :file_cache, :file_size, :file_type, :nbpages, :version_number, :active, :product_id)
  end
end
