FactoryGirl.define do

  sequence :aname do |n|
    "aname_#{n}"
  end

  factory :address do
    addressfor {|a| a.association(:location) }
  end

  factory :location do
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

  factory :org_unit do
    name { generate(:aname) }
    position 0
  end


end

