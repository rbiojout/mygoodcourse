json.extract! @comment, :id, :title, :description, :score, :product_id, :created_at, :updated_at

unless @comment.customer.nil?
  json.customer do
    json.extract! @comment.customer, :id, :name, :first_name
    json.picture @comment.customer.picture.url
  end
end