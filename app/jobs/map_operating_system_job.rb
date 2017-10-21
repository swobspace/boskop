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
  # * :fields - [:cpe, :raw_os]
  #
  def perform(options)
    options.symbolize_keys! 
    host = options.fetch(:host)
    @fields = options.fetch(:fields) { [:cpe, :raw_os] }
    raise(ArgumentError, "not a host object") unless host.is_a? Host
    new_osm = false

    @fields.each do |f|
      value = host.send(f)
      unless value.blank?
        osm = OperatingSystemMapping.find_or_create_by(field: f.to_s, value: value)
        new_osm = true
      end
    end
    map_operating_systems if new_osm
    host.assign_operating_system
  end

private
  #
  # search for a matching operating system and assign
  #
  def map_operating_systems
    return unless OperatingSystemMapping.where(operating_system_id: nil).any?
    OperatingSystem.all.each do |os|
      next if os.matching_pattern.blank?
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
end
