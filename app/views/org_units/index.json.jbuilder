json.array!(@org_units) do |org_unit|
  json.extract! org_unit, :id, :name, :description, :ancestry, :ancestry_depth, :position
  json.url org_unit_url(org_unit, format: :json)
end
