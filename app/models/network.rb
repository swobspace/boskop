require 'cidr_addresses'
class Network < ActiveRecord::Base
  # -- associations
  belongs_to :location
  # -- configuration
  # -- validations and callbacks
  validates :name, :netzwerk, :location_id, presence: true

  def to_s
    "#{self.netzwerk.to_cidr_s} / #{self.location.try(:ort)}"
  end


end
