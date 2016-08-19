json.extract! topic, :id, :name, :description, :position, :slug, :country_id, :created_at, :updated_at
json.url topic_url(topic, format: :json)