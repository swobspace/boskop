class Host < ApplicationRecord
  # -- associations
  belongs_to :operating_system, optional: true
  belongs_to :host_category, optional: true
  belongs_to :location, optional: true
  has_many :merkmale, as: :merkmalfor, dependent: :destroy
  has_many :vulnerabilities, dependent: :destroy

  accepts_nested_attributes_for :merkmale, allow_destroy: true
  validates_associated :merkmale

  # -- configuration
  # -- validations and callbacks
  validates :ip, presence: :true, uniqueness: true
  validates :lastseen, presence: :true

  before_save :set_location
  before_save :check_operating_system

  def to_s
    "#{ip} (#{name})"
  end

  #
  # caching location identifier lid
  #
  def lid
    Rails.cache.fetch("#{cache_key}/lid", expires_in: 7.days) do
      self.location&.lid
    end
  end

  def assign_operating_system
    if (cpe.blank? && raw_os.blank?)
      return
    end
    [:cpe, :raw_os].each do |field|
      os = OperatingSystemMapping.
             where("field = :field and value = :value",
                    field: field, value: self.send(field))
      next if os.empty?
      if os.count == 1
        if self.persisted?
          self.update_column(:operating_system_id, os.first.operating_system_id)
        else
          operating_system_id = os.first.operating_system_id
        end
        break
      else
        puts "WARNING: more than one mapping found, skipping\n#{os.inspect}"
        return false
      end
    end
    return true
  end


private

  #
  # define setter and getter for merkmale
  #
  def method_missing(key, *args)
    case key
    when *merkmal_attributes_getter
      merkmale.where("merkmalklasse_id = :id", id: mk_id(key)).first&.value
    when *merkmal_attributes_setter
      merkmal = merkmale.find_or_initialize_by(merkmalklasse_id:  mk_id(key))
      merkmal.value = args.first
      if merkmal.save
        merkmal.value
      else
        raise ArgumentError
      end
    else
      super
    end
  end

  def merkmal_attributes
    Merkmalklasse.where(for_object: 'Host').pluck(:tag).map {|t| "merkmal_#{t}" }
  end

  def merkmal_attributes_getter
    merkmal_attributes.map(&:to_sym)
  end
  def merkmal_attributes_setter
    merkmal_attributes.map {|a| "#{a}=".to_sym }
  end

  def mk_id(rawkey)
    key = rawkey.to_s.sub(/\Amerkmal_/, '').sub(/=\z/, '')
    Merkmalklasse.where(for_object: 'Host', tag: key).first&.id
  end

  def set_location
    if self.location.nil?
      networks = Network.best_match(self.ip)
      if networks.count == 1
        self.location = networks.first.location
      end
    end
    true
  end

  def check_operating_system
    check_raw_os
    assign_operating_system
    return true
  end

  def check_raw_os
    if self.operating_system_id_changed?
      # let it unchanged pass
    elsif self.raw_os_changed? && self.cpe_changed?   # both
      # clear existing os
      self.operating_system_id = nil
    elsif raw_os_changed? ^ cpe_changed? # xor
      # clear existing os
      self.operating_system_id = nil
      # clear the unchanged field to avoid inconsistency
      if self.cpe_changed?
        self.raw_os = "" 
      else
        self.cpe    = ""
      end
    end
    true
  end

end
