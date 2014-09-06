class Merkmalklasse < ActiveRecord::Base
  # -- associations
  # has_many :services

  # -- configuration
  FORMATE = ['string', 'date', 'number', 'telephone', 'dropdown' ]


  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true
  validates :format, presence: true, inclusion: { in: FORMATE }

  def to_s
    "#{name}"
  end
end
