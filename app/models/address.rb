class Address < ActiveRecord::Base
  # -- associations
  belongs_to :addressfor, polymorphic: true

  # -- configuration
  # -- validations and callbacks


  def to_s
    "#{streetaddress}, #{plz} #{ort}"
  end
end
