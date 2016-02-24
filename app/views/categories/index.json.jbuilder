json.array!(@categories) do |category|
  json.extract! category, :id, :name, :description, :family_id
  json.url category_url(category, format: :json)
end
