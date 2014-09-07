class Merkmal < ActiveRecord::Base
  belongs_to :merkmalfor, polymorphic: true
  belongs_to :merkmalklasse
end
