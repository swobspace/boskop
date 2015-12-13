class Line < ActiveRecord::Base
  # -- associations
  belongs_to :access_type
  belongs_to :framework_contract
  belongs_to :line_state
  belongs_to :location_a, class_name: "Location", inverse_of: :lines
  belongs_to :location_b, class_name: "Location", inverse_of: :lines

  # -- configuration

  # -- validations and callbacks
  validates :name, presence: :true, uniqueness: true
  validates :location_a_id, :access_type_id, :line_state_id,
            :description, presence: :true
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
