json.array!(@framework_contracts) do |framework_contract|
  json.extract! framework_contract, :id, :name, :description, :contract_start, :contract_end, :contract_period, :period_of_notice, :period_of_notice_unit, :renewal_period, :renewal_unit, :active
  json.url framework_contract_url(framework_contract, format: :json)
end
