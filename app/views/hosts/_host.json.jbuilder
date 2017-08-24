json.extract! host, :id, :name, :description, :ip, :cpe, :raw_os, :operating_system_id, :lastseen, :mac, :host_category_id, :location_id, :created_at, :updated_at
json.url host_url(host, format: :json)
