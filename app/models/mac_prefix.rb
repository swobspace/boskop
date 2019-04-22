class MacPrefix < ApplicationRecord
  # -- associations
  # -- configuration
  # -- validations and callbacks
  validates :oui, presence: true, uniqueness: { case_sensitive: false }

  def to_s
    "#{oui} #{vendor}"
  end
end
