json.array!(@reviews) do |review|
  json.extract! review, :id, :title, :description, :score, :product_id
  json.url review_url(review, format: :json)
  json.customer do
    unless review.customer.nil?
      json.extract! review.customer, :id, :name, :first_name
      json.picture review.customer.picture.url
    end
  end
end
