class Line < ActiveRecord::Base
  belongs_to :access_type
  belongs_to :framework_contract
  belongs_to :line_state
end
