require 'uri'

class Merkmalklasse < ApplicationRecord
  default_scope { order 'position ASC' }
  # -- associations
  has_many :merkmale, dependent: :destroy

  acts_as_list scope: [:for_object]

  # -- configuration
  FORMATE = ['string', 'date', 'number', 'telephone', 'dropdown', 'linkindex' ]
  OBJECTS = ['OrgUnit', 'Location', 'Network', 'Host']
  VISIBLES = ['index']

  serialize :visible, Array
  serialize :possible_values, Array

  # -- validations and callbacks
  after_commit :flush_cache

  validates :name, presence: true
  validates_uniqueness_of :name, scope: [ :for_object ]
  validates :position, presence: true
  validates :format, presence: true, inclusion: { in: FORMATE }
  validates :for_object, presence: true, inclusion: { in: OBJECTS }
  validates :visible, presence: true # , inclusion: { in: VISIBLES }
  validates :tag, presence: true, uniqueness: { scope: :for_object },
              format: { 
                with: /\A[a-z_]+\z/,
                message: "only allows letters a-z and '_'"
              }
  # -- 
  # not perfect, since it allows 'http://', but its a start
  validates :baselink, format: URI::regexp(%w(http https)), allow_blank: true

  def to_s
    "#{name}"
  end

  def self.visibles(obj, action)
    Merkmalklasse.where(["for_object = ?", obj.to_s.camelize]).
      reject {|mk| !mk.visible.include?(action) }
  end

  def pvalues
    return "" if possible_values.nil?
    possible_values.join("; ")
  end

  def pvalues=(values)
    self[:possible_values] = values.gsub(/\r\n/,';').gsub(/\n/,';').
                               gsub(/; */,';').strip.split(/;/)
  end

  def flush_cache
    Rails.cache.delete_matched(Regexp.new("location/merkmale"))
    Rails.cache.delete_matched(Regexp.new("orgunit/merkmale"))
  end
end
