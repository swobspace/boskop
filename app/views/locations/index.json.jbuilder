json.array!(@locations) do |location|
  json.extract! location, :id, :name, :description, :ancestry, :ancestry_depth, :position
  json.url location_url(location, format: :json)
end
