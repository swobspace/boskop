class NessusScan < ApplicationRecord
  # -- associations

  # -- configuration
  # -- validations and callbacks
  validates :uuid, presence: :true, uniqueness: true
  validates :nessus_id, :name, :status, :last_modification_date, presence: :true

  def to_s
    "#{nessus_id} / #{name} / #{last_modification_date}"
  end

end
