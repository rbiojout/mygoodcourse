# == Schema Information
#
# Table name: attachments
#
#  id             :integer          not null, primary key
#  file           :string
#  file_size      :integer
#  file_type      :string
#  nbpages        :integer
#  version_number :decimal(, )
#  active         :boolean
#  product_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  position       :integer
#  iv             :binary
#  key            :binary
#
# Indexes
#
#  index_attachments_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_1e84c5b1fb  (product_id => products.id)
#

class Attachment < ApplicationRecord
  # attr_accessible :file, :file_size, :file_type, :nbpages, :version_number, :active
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
    # only if backgrounder
    # self.process_file_upload = true
    file.cache_stored_file!
    file.retrieve_from_cache!(file.cache_name)
    file.recreate_versions!
    save!
  rescue => ex
    STDERR.puts "ERROR: MyModel: #{id} -> #{ex.backtrace}: #{ex.message} (#{ex.class})"
  end

private

  def update_file_attributes
    if file.present? && file_changed?
      self.file_type = file.file.content_type
      self.file_size = file.file.size
      # count the number of pages for the pdf with ImageMagic identity
      # slow method
      # image = MiniMagick::Image.open(file.file.file)
      # this method is to slow we use Grim instead
      # pdf = ::Magick::Image.read(file.file.file)
      pdf = Grim.reap(file.file.file)
      self.nbpages = pdf.count
      # image.identify do |b|
      # b.format '%n'
      # end
      # we encrypt to seal the file
      encrypt
    end
  end

  # the file is encrypted
  # we need the iv and key to decrypt
  def encrypt
    if file.present? && file
      # encryption
      cipher = OpenSSL::Cipher.new('aes-256-cbc')
      cipher.encrypt
      self.key = cipher.random_key
      self.iv = cipher.random_iv

      buf = ''
      updloaded_file = file.file.file
      File.rename(updloaded_file, updloaded_file + '.enc')
      Rails.logger.debug(".........#{updloaded_file + '.enc'}")
      File.open(updloaded_file, 'wb') do |outf|
        File.open(updloaded_file + '.enc', 'rb') do |inf|
          outf << cipher.update(buf) while inf.read(4096, buf)
          outf << cipher.final
        end
      end
      File.delete(updloaded_file + '.enc')

    end
  end

  def increment_version
    self.version_number = (product.attachments.first.version_number || 0) + 1.0
  rescue
    self.version_number = 1.0
  end
end
