json.extract! nessus_scan, :id, :nessus_id, :uuid, :name, :status, :last_modification_date, :import_state, :created_at, :updated_at
json.url nessus_scan_url(nessus_scan, format: :json)
