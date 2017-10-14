class MapOperatingSystemJob < ApplicationJob
  queue_as :default

  #
  # create missing operating system mappings from new host data
  # an operating system with a matching_pattern must exists,
  # otherwise the operating system can be manually assigned to
  # a given operating system matrix record.
  # 
  # options:
  # * :host - new or updated host object
  #
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
    map_operating_systems
    assign_operating_system(host)
  end

private
  #
  # search for a matching operating system and assign
  #
  def map_operating_systems
    return unless OperatingSystemMapping.where(operating_system_id: nil).any?
    OperatingSystem.all.each do |os|
      os.matching_pattern.chomp.split(/\n/).each do |pattern|
        m = pattern.match(/\A(\w+):(.*)\z/)
        field = m[1]
        value = m[2]
        OperatingSystemMapping.
          where(operating_system_id: nil).
          where("field = :field and value like :value",
                 field: field, value: "%#{value}%").
          update_all(operating_system_id: os.id)
      end
    end
  end

  #
  # search for a matching operating system and assign
  #
  def assign_operating_system(host)
    if (host.cpe.blank? && host.raw_os.blank?)
      return
    end
    [:cpe, :raw_os].each do |field|
      os = OperatingSystemMapping.
	     where("field = :field and value = :value",
		    field: field, value: host.send(field))
      next if os.empty?
      if os.count == 1
	host.update(operating_system_id: os.first.operating_system_id)
        break
      else
	puts "WARNING: more than one mapping found, skipping\n#{os.inspect}"
      end
    end

  end
end
