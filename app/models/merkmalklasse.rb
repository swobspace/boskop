class Merkmalklasse < ActiveRecord::Base
  # -- associations
  has_many :merkmale

  acts_as_list scope: [:for_object]

  # -- configuration
  FORMATE = ['string', 'date', 'number', 'telephone', 'dropdown' ]
  OBJECTS = ['OrgUnit', 'Location']
  VISIBLES = ['index']

  serialize :visible, Array
  serialize :possible_values

  # -- validations and callbacks
  validates :name, presence: true, uniqueness: true
  validates :position, presence: true
  validates :format, presence: true, inclusion: { in: FORMATE }
  validates :for_object, presence: true, inclusion: { in: OBJECTS }
  validates :visible, presence: true # , inclusion: { in: VISIBLES }

  def to_s
    "#{name}"
  end
end
