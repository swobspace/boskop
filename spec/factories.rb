FactoryGirl.define do

  sequence :newlid do |n|
    "lid_#{n}"
  end

  sequence :aname do |n|
    "aname_#{n}"
  end

  sequence :tag do |n|
    (0...20).map { ('a'..'z').to_a[rand(26)] }.join
  end

  sequence :aip do |n|
    "192.0.2.#{n % 256}"
  end

  factory :access_type do
    name { generate(:aname) }
  end

  factory :address do
    addressfor {|a| a.association(:location) }
  end

  factory :framework_contract do
    name { generate(:aname) }
  end

  factory :host do
    ip { generate(:aip) }
    lastseen { Date.today }
  end

  factory :host_category do
    name { generate(:aname) }
  end

  factory :line do
    name { generate(:aname) }
    line_state
    access_type
    association :location_a, factory: :location
    description "internet access just for fun"
  end

  factory :line_state do
    name { generate(:aname) }
    active false
  end

  factory :location do
    lid  { generate(:newlid) }
    name { generate(:aname) }
    position 0
  end

  factory :merkmalklasse do
    name { generate(:aname) }
    format 'string'
    position 0
    for_object Merkmalklasse::OBJECTS.first
    visible { Merkmalklasse::VISIBLES }
    tag { generate(:tag) }
  end

  factory :merkmal do
    value 'test'
    merkmalklasse
    merkmalfor {|a| a.association(:location) }
  end

  factory :network do
    location
    netzwerk "192.0.2.0/24"
  end

  factory :operating_system do
    name { generate(:aname) }
  end

  factory :operating_system_mapping do
    field "cpe"
    value "cpe:/os:microsoft:embedded::"
  end

  factory :org_unit do
    name { generate(:aname) }
    position 0
  end


end

