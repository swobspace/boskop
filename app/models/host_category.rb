class HostCategory < ApplicationRecord
  # -- associations
  has_many :hosts, dependent: :restrict_with_error
  has_many :vulnerabilities, through: :hosts

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: :true, uniqueness: true


  def to_s
    "#{name}"
  end
end
