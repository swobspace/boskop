require 'cidr_addresses'
class Network < ActiveRecord::Base
  # -- associations
  belongs_to :location
  has_many :merkmale, as: :merkmalfor, dependent: :destroy

  accepts_nested_attributes_for :merkmale, allow_destroy: true
  validates_associated :merkmale

  # -- configuration
  # -- validations and callbacks
  validates :name, :netzwerk, :location_id, presence: true

  def to_s
    "#{self.netzwerk.to_cidr_s} / #{self.location.try(:ort)}"
  end


end
