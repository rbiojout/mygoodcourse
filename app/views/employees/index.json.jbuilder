json.array!(@employees) do |employee|
  json.extract! employee, :id, :name, :first_name, :entry_date, :mobile, :picture, :role, :active
  json.url employee_url(employee, format: :json)
end
