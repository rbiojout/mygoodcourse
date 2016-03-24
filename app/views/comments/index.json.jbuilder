json.array!(@comments) do |comment|
  json.extract! comment, :id, :title, :description, :score, :product_id
  json.url comment_url(comment, format: :json)
end
