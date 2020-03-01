class SoftwareRawDatum < ApplicationRecord
  # -- associations
  belongs_to :software, optional: true

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true

  def to_s
    "#{name} (#{vendor})"
  end

end
