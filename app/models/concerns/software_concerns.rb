module SoftwareConcerns
  extend ActiveSupport::Concern

  included do
  end # included do

  def status(flag)
    today = Date.today
    if red.present? && today >= red
      color = 'red'
      date  = red
    elsif yellow.present? && today >= yellow
      color = 'yellow'
      date  = yellow
    elsif green.present? && today >= green
      color = 'green'
      date  = green
    else
      color = 'grey'
    end

    case flag 
    when :color
      color
    when :show_date
      date
    else
      raise RuntimeError, "flag #{flag} not implemented"
    end
  end

end

