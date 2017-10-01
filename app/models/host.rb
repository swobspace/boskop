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
end
