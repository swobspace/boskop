class Address < ApplicationRecord
  # -- associations
  belongs_to :addressfor, polymorphic: true

  # -- configuration
  # -- validations and callbacks

  validates :plz, format: { with:/\A[0-9]+\z/ }, allow_blank: true


  def to_s
    "#{streetaddress}, #{plz} #{ort}"
  end
end
