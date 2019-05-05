class NetworkInterface < ApplicationRecord
  # -- associations
  belongs_to :host, inverse_of: :network_interfaces
  # -- configuration
  # -- validations and callbacks
  validates :ip, :lastseen, presence: true

  before_save :check_mac_address

  scope :current, -> { where("network_interfaces.lastseen >= ?", 1.month.before(Date.today)) }

  def to_s
    "#{ip} / #{mac} / #{oui_vendor}"
  end

private

  def check_mac_address
    return true if mac.blank?
    if mac !~ /[0-9A-F]{12}/
      self[:mac] = mac.upcase.gsub(/[^0-9A-F\n]/, '').split(/\n/).first
    end
    if oui_vendor.blank? || mac_changed?
      self[:oui_vendor] = MacPrefix.where(oui: mac[0..5]).limit(1).first&.vendor
    end
    true
  end

end
