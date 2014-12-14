# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

if Rails.env == "development"
  require ::File.expand_path('../lib/inject_remote_user',  __FILE__)
  use InjectRemoteUser
else
  raise "Häää"
end

run Rails.application
