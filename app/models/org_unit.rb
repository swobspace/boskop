class OrgUnit < ApplicationRecord
  # -- associations
  has_many :merkmale, as: :merkmalfor, dependent: :destroy
  has_many :addresses, as: :addressfor, dependent: :destroy

  # -- configuration
  has_ancestry :cache_depth =>true, :orphan_strategy => :adopt
  acts_as_list :scope => [:ancestry]

  accepts_nested_attributes_for :merkmale, :addresses,  allow_destroy: true
  validates_associated :merkmale, :addresses

  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true

  def to_s
    "#{name.to_s}"
  end

end
