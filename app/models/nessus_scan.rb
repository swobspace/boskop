class NessusScan < ApplicationRecord
  # -- associations

  # -- configuration
  # -- validations and callbacks
  validates :nessus_id, presence: :true, uniqueness: true
  validates :uuid, :name, :status, :last_modification_date, presence: :true

  def to_s
    "#{nessus_id} / #{name} / #{last_modification_date}"
  end

end
