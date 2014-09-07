FactoryGirl.define do

  sequence :name do |n|
    "name_#{n}"
  end

  factory :location do
    name
    position 0
  end

  factory :merkmalklasse do
    name
    format 'string'
    position 0
    for_object Merkmalklasse::OBJECTS.first
    visible { Merkmalklasse::VISIBLES }
  end

  factory :merkmal do
    association :merkmalfor, factory: location
    value 'test'
    merkmalklasse
  end

end

