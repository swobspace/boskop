class SoftwareRawDatum < ApplicationRecord
  # -- associations
  belongs_to :software, optional: true
  has_many :installed_software, inverse_of: :software_raw_datum, dependent: :destroy

  # -- configuration
  # -- validations and callbacks
  validates :name, presence: true, uniqueness: {
              scope: [:vendor, :version, :operating_system]
            }

  def to_s
    "#{name} (#{vendor})"
  end

end
