# config/initializers/zeitwerk.rb
Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    "xml" => "XML",
    "nmap" => "NMAP",
    "open_vas" => "OpenVAS",
    "ipaddr" => "IPAddr"
  )
end
