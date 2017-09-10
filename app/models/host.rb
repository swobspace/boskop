class Host < ApplicationRecord
  # -- associations
  belongs_to :operating_system, optional: true
  belongs_to :host_category, optional: true
  belongs_to :location, optional: true

  # -- configuration
  # -- validations and callbacks
  validates :ip, presence: :true, uniqueness: true
  validates :lastseen, presence: :true

  def to_s
    "#{ip} (#{name})"
  end

end
