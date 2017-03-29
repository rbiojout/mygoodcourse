json.extract! article, :id, :name, :description, :position, :counter_cache, :slug, :topic_id, :created_at, :updated_at
json.url topic_article_url(article, topic_id: article.topic_id, format: :json)
