# create os mappings from host data and operating_system matching_patterns
# 

namespace :operating_system do
  task all: %w(scan_hosts add_operating_system)

  desc "scan hosts for new operating systems"
  task :scan_hosts => :environment do
    [:cpe, :raw_os].each do |f|
      Host.pluck(f).sort.uniq.each do |val|
        OperatingSystemMapping.find_or_create_by(field: f.to_s, value: val)
      end
    end
  end

  desc "add operating_system to os mappings"
  task :add_operating_system => :environment do
    OperatingSystem.all.each do |os|
      os.matching_pattern.chomp.split(/\n/).each do |pattern|
        m = pattern.match(/\A(\w+):(.*)\z/)
        field = m[1]
        value = m[2]
        puts "#{field} / #{value}"
        OperatingSystemMapping.
          where(operating_system_id: nil).
          where("field = :field and value like :value", 
                 field: field, value: "%#{value}%").
          update_all(operating_system_id: os.id)
      end
    end
  end
end
