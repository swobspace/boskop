class Location < ActiveRecord::Base
  # -- associations
  has_many :merkmale, as: :merkmalfor, dependent: :destroy
  has_many :addresses, as: :addressfor, dependent: :destroy
  has_many :networks, dependent: :destroy
  has_many :lines_a, class_name: "Line", foreign_key: :location_a_id,
            dependent: :restrict_with_error, inverse_of: :location_a
  has_many :lines_b, class_name: "Line", foreign_key: :location_b_id,
            dependent: :restrict_with_error, inverse_of: :location_b

  # -- configuration
  has_ancestry :cache_depth =>true, :orphan_strategy => :adopt
  acts_as_list :scope => [:ancestry]

  accepts_nested_attributes_for :merkmale, :addresses,  allow_destroy: true
  validates_associated :merkmale, :addresses

  # -- validations and callbacks
  validates :name, :lid, presence: true, uniqueness: true

  def to_s
    "#{name.to_s}"
  end

  def to_str
    "#{lid} / #{name.to_s} / #{ort}"
  end

  def ort
    "#{self.addresses.first.try(:ort)}"
  end

end
