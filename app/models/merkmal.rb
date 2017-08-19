class Merkmal < ActiveRecord::Base
  # -- associations
  belongs_to :merkmalfor, polymorphic: true
  belongs_to :merkmalklasse

  # -- configuration
  # -- validations and callbacks

  validates :merkmalklasse_id, presence: true
  validates :value, presence:   { if: :is_mandantory? }
  validates_uniqueness_of :value, scope: [ :merkmalklasse_id ], 
                                  if: :uniqueness_required?

  before_create :merkmalklasse_unique?
  after_commit :flush_cache

  scope :mandantory, -> {
    joins(:merkmalklasse).where("merkmalklassen.mandantory = ?", true)
  }
  scope :optional, -> {
    joins(:merkmalklasse).where("merkmalklassen.mandantory = ?", false)
  }

  def to_s
    "#{value.to_s}"
  end

  private

  def uniqueness_required?
    (!self.merkmalklasse.nil?) && self.merkmalklasse.unique
  end

  def is_mandantory?
    (!self.merkmalklasse.nil?) && self.merkmalklasse.mandantory
  end

  def merkmalklasse_unique?
    if Merkmal.where(merkmalfor_id: self.merkmalfor_id,
                  merkmalfor_type: self.merkmalfor_type,
                  merkmalklasse_id: self.merkmalklasse_id).empty?
      true
    else
      errors.add(:base, 'only one attribute of each merkmalklasse allowed')
      throw :abort
    end
  end

  def flush_cache
    Rails.cache.delete(["location/merkmale", self.merkmalfor_id, self.merkmalklasse_id])
    Rails.cache.delete(["orgunit/merkmale", self.merkmalfor_id, self.merkmalklasse_id])
  end
end


