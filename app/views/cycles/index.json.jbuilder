json.array!(@cycles) do |cycle|
  json.extract! cycle, :id, :name, :description, :position
  json.url cycle_url(cycle, format: :json)
end
