FactoryGirl.define do

  sequence :name do |n|
    "name_#{n}"
  end

  factory :merkmalklasse do
    name
    format 'string'
    position 0
    for_object Merkmalklasse::OBJECTS.first
    visible { Merkmalklasse::VISIBLES }
  end

end

