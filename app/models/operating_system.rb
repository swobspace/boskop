class OperatingSystem < ApplicationRecord
  # -- associations
  has_many :hosts, dependent: :restrict_with_error
  has_many :vulnerabilities, through: :hosts
  has_many :operating_system_mappings, dependent: :restrict_with_error

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: :true, uniqueness: true

  def to_s
    "#{name}"
  end

end
