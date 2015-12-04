require 'wob_support'

class LineState < ActiveRecord::Base
  # -- associations
  has_many :lines, dependent: :nullify

  # -- configuration
  # -- validations and callbacks
  watch_for_dependencies :on => [:lines]
  before_destroy :ensure_has_no_dependencies

  validates :name, presence: :true, uniqueness: true

  def to_s
    "#{name}"
  end

end
