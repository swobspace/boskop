json.array!(@merkmalklassen) do |merkmalklasse|
  json.extract! merkmalklasse, :id, :name, :description, :format, :possible_values, :mandantory, :unique, :position, :for_object, :visible
  json.url merkmalklasse_url(merkmalklasse, format: :json)
end
