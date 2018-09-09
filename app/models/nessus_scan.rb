class NessusScan < ApplicationRecord
  # -- associations

  # -- configuration
  IMPORT_STATES = ['new', 'done', 'failed']
  IMPORT_MODES  = ['unassigned', 'auto', 'manual', 'ignore']
  # -- validations and callbacks
  validates :nessus_id, presence: :true, uniqueness: true
  validates :uuid, :name, :status, :last_modification_date, presence: :true
  validates :import_state, :allow_blank => false, 
              :inclusion => { 
                in: IMPORT_STATES, 
                message: "Select one of #{IMPORT_STATES.join(", ")}"
              }
  validates :import_mode, :allow_blank => false, 
              :inclusion => { 
                in: IMPORT_MODES, 
                message: "Select one of #{IMPORT_MODES.join(", ")}"
              }


  def to_s
    "#{nessus_id} / #{name} / #{last_modification_date}"
  end

end
