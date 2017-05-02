class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :slug, :topic_id, :created_at, :updated_at, :counter_cache
end
