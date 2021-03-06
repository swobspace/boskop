class SoftwareCategory < ApplicationRecord
  # -- associations
  has_many :software, dependent: :restrict_with_error
  belongs_to :software_group, optional: true

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true

  def to_s
    "#{name.to_s}"
  end
end
