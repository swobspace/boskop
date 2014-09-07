class Merkmal < ActiveRecord::Base
  # -- associations
  belongs_to :merkmalfor, polymorphic: true
  belongs_to :merkmalklasse

  # -- configuration
  # -- validations and callbacks

  validates :merkmalfor_id, :merkmalfor_type, :merkmalklasse_id, presence: true

  def to_s
    "#{value.to_s}"
  end
end


