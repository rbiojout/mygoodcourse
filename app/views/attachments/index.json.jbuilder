json.array!(@attachments) do |attachment|
  json.extract! attachment, :id, :file, :file_size, :file_type, :nbpages, :version_number, :active, :product_id
  json.url attachment_url(attachment, format: :json)
end
