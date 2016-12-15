json.extract! @review, :id, :title, :description, :score, :product_id, :created_at, :updated_at

unless @review.customer.nil?
  json.customer do
    json.extract! @review.customer, :id, :name, :first_name
    json.picture @review.customer.picture.url
  end
end
