json.array!(@networks) do |network|
  json.extract! network, :id, :location_id, :netzwerk, :description
  json.url network_url(network, format: :json)
end
