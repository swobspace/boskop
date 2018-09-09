env :PATH, '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
env :RAILS_ENV, :production
env :http_proxy, nil
env :https_proxy, nil

set :output, "#{path}/log/whenever-boskop.log"

every 1.day, at: ['12:30', '19:30'] do
  runner "Nessus::ListScansJob.perform_later"
end

every 1.day, at: ['12:40', '18:10'] do
  runner "Nessus::ImportScansJob.perform_later"
end

