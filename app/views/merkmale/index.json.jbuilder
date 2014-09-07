json.array!(@merkmale) do |merkmal|
  json.extract! merkmal, :id, :merkmalfor_id, :merkmalfor_type, :merkmalklasse_id, :value
  json.url merkmal_url(merkmal, format: :json)
end
