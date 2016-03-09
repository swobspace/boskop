module LineConcerns
  extend ActiveSupport::Concern

  included do
  end

  def bandwith
    msg = ""
    if bw_upstream == bw_downstream
      msg = "#{bw_downstream}"
    else
      msg = "#{bw_downstream}/#{bw_upstream}"
    end
    msg += " #{Boskop.bandwith_base_unit}"

    unless bw2_downstream == 0.0
      msg += " primary + "
      if bw2_upstream == bw2_downstream
        msg += "#{bw2_downstream}"
      else
        msg += "#{bw2_downstream}/#{bw2_upstream}"
      end
      msg += " #{Boskop.bandwith_base_unit} secondary"
    end
    msg

  end

  def product
    "#{access_type} #{bandwith}"
  end

end
