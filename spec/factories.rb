FactoryGirl.define do

  sequence :newlid do |n|
    "lid_#{n}"
  end

  sequence :aname do |n|
    "aname_#{n}"
  end

  factory :address do
    addressfor {|a| a.association(:location) }
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

  factory :org_unit do
    name { generate(:aname) }
    position 0
  end


end

