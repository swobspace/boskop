class OperatingSystemMapping < ApplicationRecord
  # -- associations
  belongs_to :operating_system, optional: true

  # -- configuration
  # -- validations and callbacks
  validates :field, :value, presence: :true

  def to_s
    "#{field}:#{value}"
  end

end
