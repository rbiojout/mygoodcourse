json.array!(@comments) do |comment|
  json.extract! comment, :id, :title, :description, :score, :product_id
  json.url comment_url(comment, format: :json)
  json.customer do
    unless comment.customer.nil?
      json.extract! comment.customer, :id, :name, :first_name
      json.picture comment.customer.picture.url
    end
  end
end
