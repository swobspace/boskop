class Contact < ApplicationRecord
  # -- associations
  has_many :responsibilities, dependent: :restrict_with_error

  # -- configuration
  accepts_nested_attributes_for :responsibilities,
                                allow_destroy: true,
                                reject_if: proc { |att| att['contact_id'].blank? }

  # -- validations and callbacks
  validates :sn, :givenname, presence: true
  validates :mail, uniqueness: { case_sensitive: false }, allow_blank: true

  def to_s
    if title.present?
      "#{sn}, #{title} #{givenname}"
    else
      "#{sn}, #{givenname}"
    end
  end

  def to_str
    "#{to_s} <#{mail}>"
  end

  def name
    if title.present?
      "#{title} #{givenname} #{sn}"
    else
      "#{givenname} #{sn}"
    end
  end

end
