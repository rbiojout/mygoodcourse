json.extract! article, :id, :name, :description, :position, :counter_cache, :slug, :topic_id, :created_at, :updated_at
json.url article_url(article, format: :json)