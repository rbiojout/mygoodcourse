json.extract! post, :id, :name, :description, :customer_id, :visual, :created_at, :updated_at
json.url post_url(post, format: :json)