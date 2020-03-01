class Software < ApplicationRecord
  # -- associations
  has_many :software_raw_data, dependent: :restrict_with_error
  belongs_to :software_category, optional: true

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true

  def to_s
    "#{name} (#{vendor})"
  end

end
