class OperatingSystem < ApplicationRecord
  # -- associations
  has_many :hosts

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: :true, uniqueness: true

  def to_s
    "#{name}"
  end

end
