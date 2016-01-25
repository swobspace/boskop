module LinesHelper
  def bandwith(line)
    msg = ""
    if line.bw_upstream == line.bw_downstream
      msg = "#{line.bw_downstream}"
    else
      msg = "#{line.bw_downstream}/#{line.bw_upstream}"
    end
  end
  def bandwith2(line)
    msg = ""
    unless line.bw2_downstream == 0.0
      if line.bw2_upstream == line.bw2_downstream
        msg = "#{line.bw2_downstream}"
      else
        msg = "#{line.bw2_downstream}/#{line.bw2_upstream}"
      end
    end
    msg
  end
end
