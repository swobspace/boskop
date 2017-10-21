require 'cidr_addresses'
class Network < ApplicationRecord
  include NetworkConcerns
  # -- associations
  belongs_to :location, optional: true
  has_many :merkmale, as: :merkmalfor, dependent: :destroy

  accepts_nested_attributes_for :merkmale, allow_destroy: true
  validates_associated :merkmale

  # -- configuration
  # -- validations and callbacks
  validates :netzwerk, :location_id, presence: true
  validates_uniqueness_of :netzwerk, scope: :location_id

  def to_s
    "#{self.netzwerk.try(:to_cidr_s)} / #{self.location.try(:ort)}"
  end

  def to_str
    "#{self.netzwerk.try(:to_cidr_s)}"
  end

end
