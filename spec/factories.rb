FactoryGirl.define do

  sequence :name do |n|
    "name_#{n}"
  end

  factory :merkmalklasse do
    name
    format 'string'
  end

end

