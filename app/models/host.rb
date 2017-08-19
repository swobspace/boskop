class Host < ApplicationRecord
  # -- associations
  belongs_to :operating_system
  belongs_to :host_category
  belongs_to :location

  # -- configuration
  # -- validations and callbacks
  validates :ip, presence: :true, uniqueness: true
  validates :lastseen, presence: :true

  def to_s
    "#{ip} (#{name})"
  end

end
