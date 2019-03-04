class OperatingSystem < ApplicationRecord
  # -- associations
  has_many :hosts, dependent: :nullify
  has_many :vulnerabilities, through: :hosts
  has_many :operating_system_mappings, dependent: :nullify

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: :true, uniqueness: true

  def to_s
    "#{name}"
  end

end
