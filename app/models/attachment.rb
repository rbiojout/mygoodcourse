class Attachment < ActiveRecord::Base

  #attr_accessible :file, :file_size, :file_type, :nbpages, :version_number, :active
  belongs_to :product
  # we want the new ones at the begining of the list
  acts_as_list scope: :product, add_new_at: :top


  mount_uploader :file, DocumentUploader
  validates :file, presence: true

  # method for update and create
  before_create :update_file_attributes
  # method after the creation of a new attachment
  before_save :increment_version

  default_scope -> { order(position: :asc) }

  # All featured products
  scope :featured, -> { where(featured: true) }

  def reprocess_versions
    begin
      # only if backgrounder
      #self.process_file_upload = true
      self.file.cache_stored_file!
      self.file.retrieve_from_cache!(self.file.cache_name)
      self.file.recreate_versions!
      self.save!
    rescue => ex
      STDERR.puts  "ERROR: MyModel: #{id} -> #{ex.backtrace}: #{ex.message} (#{ex.class})"
    end
  end

  private

  def update_file_attributes
    if file.present? && file_changed?
      self.file_type = file.file.content_type
      self.file_size = file.file.size
      # count the number of pages for the pdf with ImageMagic identity

      #image = MiniMagick::Image.open(file.file.file)
      # this method is to slow we use Grim instead
      #pdf = ::Magick::Image.read(file.file.file)
      pdf   = Grim.reap(file.file.file)
      self.nbpages = pdf.count
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
