# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base

  after :store, :delete_thumb_file

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  include CarrierWave::MimeTypes
  #include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  #storage :fog
  storage (Rails.env.production? ? :fog : :file)

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  #process :resize_to_fit => [200, 200]
  #process :resize_to_fill => [200, 200, gravity='center']

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end


  def add_backgroung(width, height)
    image = ::Magick::Image.read(current_path + "[0]"){
      self.density = 288
      self.background_color = 'white'
      self.colorspace = Magick::RGBColorspace
    }.first

    @thumb = image.resize_to_fit(width, height)
    # we set to png to better transparency result
    #image = image.write("png:"+current_path)
    target = ::Magick::Image.new(width, height) do
      self.background_color = 'white'
    end

    @thumb.write(current_path+"thumb.png")
    # some issues of transparency appear...
    #target.alpha(::Magick::TransparentAlphaChannel)
    target.composite(@thumb, ::Magick::CenterGravity, ::Magick::OverCompositeOp).write(current_path)
    # free memory
    @thumb.destroy!
    File.delete(current_path+"thumb.png") if File.exist?(current_path+"thumb.png")
  end

  version :large do
    process :add_backgroung => [375, 525]
    process :convert => :png
    process :set_content_type

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end

  end


  version :preview, from_version: :large do
    process resize_to_fit: [250, 350]
    process :convert => :png
    process :set_content_type

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end

  version :small, from_version: :large do
    process resize_to_fit: [125, 175]
    process :convert => :png
    process :set_content_type

    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end


  def set_content_type(*args)
    self.file.instance_variable_set(:@content_type, "image/png")
  end


  def preview_pdf
    manipulate! do |img|
      img.format("png", 0)
      img.resize("350x350")
      img = yield(img) if block_given?
        img
    end
    def full_filename (for_file = model.pdf.file)
      "#{secure_token}"+ '.png'
    end
  end


  def cover_pdf (dim)
    manipulate! do |img|
      img.format("png", 0)
      img.resize("#{dim}x#{dim}")
      img = yield(img) if block_given?
      img
    end
    def full_filename (for_file = model.source.file)
      super.chomp(File.extname(super)) + '.png'
    end
  end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(pdf)
   end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end


  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  def delete_thumb_file(dummy)
    @thumb.try :delete
  end


end
