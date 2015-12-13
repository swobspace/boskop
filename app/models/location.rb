class Location < ActiveRecord::Base
  # -- associations
  has_many :merkmale, as: :merkmalfor, dependent: :destroy
  has_many :addresses, as: :addressfor, dependent: :destroy
  has_many :networks, dependent: :destroy
  has_many :lines, dependent: :restrict_with_error

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

  def ort
    "#{self.addresses.first.try(:ort)}"
  end

end
