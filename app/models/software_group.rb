class SoftwareGroup < ApplicationRecord
  # -- associations
  has_many :software_categories, dependent: :restrict_with_error

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true

  def to_s
    "#{name.to_s}"
  end

end
