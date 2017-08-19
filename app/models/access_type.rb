class AccessType < ApplicationRecord
  # -- associations
  has_many :lines, dependent: :restrict_with_error

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: :true, uniqueness: true

  def to_s
    "#{name}"
  end

end
