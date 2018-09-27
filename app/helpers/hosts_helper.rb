module HostsHelper
  def risk_button(risk)
    case risk
    when 'Critical'
      raw(%Q[<a href='#host_vulnerabilities' class="btn btn-danger" title="vulnerability risk">#{risk}</a>])
    when 'High'
      raw(%Q[<a href='#host_vulnerabilities' class="btn btn-danger" title="vulnerability risk">#{risk}</a>])
    when 'Medium'
      raw(%Q[<button type="button" class="btn btn-warning" title="vulnerability risk">#{risk}</button>])
    else
      raw(%Q[<button type="button" class="btn btn-light" title="vulnerability risk">Low</button>])
    end
  end
end
