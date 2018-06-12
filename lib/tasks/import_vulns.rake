#
# import hosts and vulnerabilities from scan files
#
# place import files in tmp/nessus
# 

namespace :import do
  namespace :vulnerabilities do

    desc "import nessus xml scan report"
    task :nessus => :environment do
      Dir["#{File.join(Rails.root, 'tmp', 'nessus')}/*.nessus"].each do |file|
        puts "Importing file #{file}"
        result = ImportNessusVulnerabilitiesService.new(file: file).call
        if result.success?
          puts "Import #{file} successful"
          File.unlink file
        else
          puts "ERROR on import ##{file }; file not removed !!!"
        end
      end
    end
  end
end
