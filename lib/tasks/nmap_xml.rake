# import nmap xml data
# 
# 1) create Rails.root / tmp / nmap
# 2) put all nmap xml files there
# 3) call rake nmap:xml:import
# 4) have fun ;-)
#

SPOOL = File.join(Rails.root, 'tmp', 'nmap')
namespace :boskop do
  namespace :nmap do
    namespace :xml do
      desc "import nmap xml data from Rails.root/tmp/nmap directory"
      task :import, [:update] => :environment do |t,args|
	update = args.fetch(:update) {:none} 
	Dir.chdir(SPOOL) do
	  Dir["*.xml"].each do |file|
	    puts "import #{file}"
	    service = ImportNmapXmlService.new(file: file, update: update.to_sym)
	    result = service.call
	    if result.success?
	      File.unlink(file)
	    else
	      puts "WARNING: some errors occured: #{result.error_message}"
	    end
	    puts "#{result.hosts.count} hosts processed"
	    puts "...done ... \n\n"
	  end
	end
      end
    end
  end
end
