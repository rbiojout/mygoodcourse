class CountrySerializer < ActiveModel::Serializer
  attributes :id, :name, :code2, :code3, :continent, :tld, :currency, :eu_member, :created_at, :updated_at
end
