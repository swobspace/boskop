class Responsibility < ApplicationRecord
  belongs_to :responsibility_for, polymorphic: true, optional: true
  belongs_to :contact, inverse_of: :responsibilities, optional: true

  # -- configuration
  acts_as_list scope: [:responsibility_for_id, :responsibility_for_type]
  # -- validations and callbacks
  validates :responsibility_for_type, :responsibility_for_id, presence: true, on: :update
  validates :contact_id, presence: true
  # validates :contact_id, presence: true
  validates :role, inclusion: Boskop.responsibility_role, allow_blank: true

  def to_s
    "#{contact.to_s} (#{title})"
  end

end
