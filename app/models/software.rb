class Software < ApplicationRecord
  include SoftwareConcerns

  # -- associations
  has_many :software_raw_data, dependent: :restrict_with_error
  belongs_to :software_category, optional: true
  has_many :installed_software, 
             -> {where('installed_software.lastseen >= ?', 6.weeks.before(Date.today))},
             through: :software_raw_data
  has_many :hosts, through: :installed_software

  # -- configuration
  PATTERN_ATTRIBUTES = [ 'name', 'vendor', 'version', 'operating_system' ]

  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true

  def to_s
    "#{name} (#{vendor})"
  end

  def patterns
    if pattern.kind_of? Hash
      [pattern]
    elsif pattern.kind_of? Array
      pattern
    else
      []
    end
  end
end
