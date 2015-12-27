json.array!(@line_states) do |line_state|
  json.extract! line_state, :id, :name, :description, :active
  json.url line_state_url(line_state, format: :json)
end
