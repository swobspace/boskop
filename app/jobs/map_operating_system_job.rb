class CreateOperatingSystemMappingsJob < ApplicationJob
  queue_as :default

  def perform(options)
    options.symbolize_keys! 
    host = options.fetch(:host)
    raise(ArgumentError, "not a host object") unless host.is_a? Host

    [:cpe, :raw_os].each do |f|
      value = host.send(f)
      unless value.blank?
        osm = OperatingSystemMapping.find_or_create_by(field: f.to_s, value: value)
      end
    end

    
  end
end
