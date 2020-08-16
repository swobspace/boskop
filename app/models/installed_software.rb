class InstalledSoftware < ApplicationRecord
  # -- associations
  belongs_to :software_raw_datum
  belongs_to :host

  # -- configuration
  # -- validations and callbacks
  validates :lastseen, presence: true
end
