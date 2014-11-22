class Address < ActiveRecord::Base
  belongs_to :addressfor, polymorphic: true
end
