json.array!(@products) do |product|
  json.extract! product, :id, :name, :sku, :permalink, :description, :active, :price, :preview
  json.url product_url(product, format: :json)
end
