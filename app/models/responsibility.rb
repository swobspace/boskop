class Responsibility < ApplicationRecord
  belongs_to :responsibility_for, polymorphic: true
  belongs_to :contact
end
