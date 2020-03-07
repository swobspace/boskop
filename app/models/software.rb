class Software < ApplicationRecord
  include SoftwareConcerns

  # -- associations
  has_many :software_raw_data, dependent: :restrict_with_error
  belongs_to :software_category, optional: true

  # -- configuration
  PATTERN_ATTRIBUTES = [ 'name', 'vendor', 'version', 'operating_system' ]

  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true

  def to_s
    "#{name} (#{vendor})"
  end

end
