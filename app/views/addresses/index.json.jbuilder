json.array!(@addresses) do |address|
  json.extract! address, :id, :addressfor_id, :addressfor_type, :streetaddress, :plz, :ort, :care_of, :postfach, :postfachplz
  json.url address_url(address, format: :json)
end
