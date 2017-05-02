class TopicSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :slug, :country_id, :created_at, :updated_at

  has_many :articles

end
