class FrameworkContract < ActiveRecord::Base
  # -- associations
  has_many :lines, dependent: :restrict_with_error

  # -- configuration

  # -- validations and callbacks
  validates :name, presence: :true, uniqueness: true
  validates :period_of_notice_unit, :renewal_unit,
            :allow_blank => true,
            :inclusion => {
              in: Boskop::PERIOD_UNITS,
              message: "Select one of #{Boskop::PERIOD_UNITS.join(", ")}"
            }

  def to_s
    "#{name}"
  end

end
