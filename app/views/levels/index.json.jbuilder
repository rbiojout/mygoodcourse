json.array!(@levels) do |level|
  json.extract! level, :id, :name, :description, :position, :cycle_id
  json.url level_url(level, format: :json)
end
