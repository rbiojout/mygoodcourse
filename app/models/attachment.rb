class Attachment < ActiveRecord::Base
  #attr_accessible :file, :file_size, :file_type, :nbpages, :version_number, :active
  belongs_to :product

  mount_uploader :file, DocumentUploader
  validates :file, presence: true

  # method for update and create
  before_save :update_file_attributes
  # method after the creation of a new attachment
  before_create :increment_version

  default_scope -> { order(created_at: :desc) }

  private

  def update_file_attributes
    if file.present? && file_changed?
      self.file_type = file.file.content_type
      self.file_size = file.file.size
      # count the number of pages for the pdf with ImageMagic identity
      image = MiniMagick::Image.open(file.file.file)
      self.nbpages = image.identify.lines.count
      #image.identify do |b|
      # b.format '%n'
      #end
    end
  end

  def increment_version
    begin
     self.version_number = (product.attachments.first.version_number||0) + 1.0
    rescue
      self.version_number = 1.0
    end
  end


end
