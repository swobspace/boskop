class Merkmal < ActiveRecord::Base
  # -- associations
  belongs_to :merkmalfor, polymorphic: true
  belongs_to :merkmalklasse

  # -- configuration
  # -- validations and callbacks

  validates :merkmalklasse_id, presence: true
  validates :value, uniqueness: { if: :uniqueness_required? },
                    presence:   { if: :is_mandantory? }

  before_create :merkmalklasse_unique?

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
      false
    end
  end
end


