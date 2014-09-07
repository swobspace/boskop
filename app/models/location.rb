class Location < ActiveRecord::Base
  # -- associations
  has_many :merkmale, as: :merkmalfor, dependent: :destroy

  # -- configuration
  has_ancestry :cache_depth =>true, :orphan_strategy => :adopt
  acts_as_list :scope => [:ancestry]

  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true

  def to_s
    "#{name.to_s}"
  end

end
