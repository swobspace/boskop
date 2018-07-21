# create os mappings from host data and operating_system matching_patterns
# 

namespace :boskop do
  namespace :operating_system do
    task all: %w(scan_hosts build_matrix assign_to_host)

    desc "scan hosts for new operating systems"
    task :scan_hosts => :environment do
      [:cpe, :raw_os].each do |f|
	Host.pluck(f).sort.uniq.each do |val|
	  OperatingSystemMapping.find_or_create_by(field: f.to_s, value: val)
	end
      end
    end

    desc "add operating_system to operating system mapping entries"
    task :build_matrix => :environment do
      OperatingSystem.all.each do |os|
	next if os.matching_pattern.blank?
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

    desc "assign operating_system to hosts"
    task :assign_to_host => :environment do
      [:cpe, :raw_os].each do |field|
	Host.where(operating_system_id: nil).where("cpe <>'' or raw_os <> ''").each do |host|
	  os = OperatingSystemMapping.
		 where("field = :field and value = :value", 
			field: field, value: host.send(field))
	  next if os.empty?
	  if os.count == 1
	    host.update(operating_system_id: os.first.operating_system_id)
	  else
	    puts "WARNING: more than one mapping found, skipping\n#{os.inspect}"
	  end
	end
      end
    end
  end
end
