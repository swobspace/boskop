module HostsHelper
  def risk_button(risk)
    case risk
    when 'Critical'
      raw(%Q[<button type="button" class="btn btn-danger" title="vulnerability risk">#{risk}</button>])
    when 'High'
      raw(%Q[<button type="button" class="btn btn-danger" title="vulnerability risk">#{risk}</button>])
    when 'Medium'
      raw(%Q[<button type="button" class="btn btn-warning" title="vulnerability risk">#{risk}</button>])
    else
      raw(%Q[<button type="button" class="btn btn-light" title="vulnerability risk">Low</button>])
    end
  end
end
