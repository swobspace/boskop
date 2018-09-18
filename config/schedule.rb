env :RAILS_ENV, :production

set :output, "#{path}/log/whenever-boskop.log"

every 1.day, at: ['05:30', '12:30', '19:30'] do
  runner "Nessus::ListScansJob.perform_now"
end

every 1.day, at: ['05:40', '12:40', '19:40'] do
  runner "Nessus::ImportScansJob.perform_now"
end

