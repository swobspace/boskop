json.array!(@lines) do |line|
  json.extract! line, :id, :name, :description, :provider_id, :location_a_id, :location_b_id, :access_type_id, :bw_upstream, :bw_downstream, :framework_contract_id, :contract_start, :contract_end, :contract_period, :period_of_notice, :period_of_notice_unit, :renewal_period, :renewal_unit, :line_state_id
  json.url line_url(line, format: :json)
end
