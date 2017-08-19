class Host < ApplicationRecord
  belongs_to :operating_system
  belongs_to :host_category
  belongs_to :location
end
