class FrameworkContract < ActiveRecord::Base
  # -- associations
  has_many :lines, dependent: :restrict_with_error

  # -- configuration
  PERIOD_UNITS = [ 'day', 'week', 'month', 'quarter', 'year' ]

  # -- validations and callbacks
  validates :name, presence: :true, uniqueness: true
  validates :period_of_notice_unit, :renewal_unit,
            :allow_blank => true,
            :inclusion => {
              in: PERIOD_UNITS,
              message: "Select one of #{PERIOD_UNITS.join(", ")}"
            }

  def to_s
    "#{name}"
  end

end
