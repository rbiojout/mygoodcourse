json.array!(@countries) do |country|
  json.extract! country, :id, :name, :code2, :code3, :continent, :tld, :currency, :eu_member
  json.url country_url(country, format: :json)
end
