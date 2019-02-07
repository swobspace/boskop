class MacPrefix < ApplicationRecord
  # -- associations
  # -- configuration
  # -- validations and callbacks
  validates :oui, presence: true, uniqueness: true

  def to_s
    "#{oui} #{vendor}"
  end
end
