namespace :installation do
  desc "all subtasks"
  task all: %w(check_yarn)

  desc "check yarn installation"
  task :check_yarn, :environment do
    yarn = `yarn help version 2> /dev/null`
    if yarn =~ /Usage: yarn/
      puts "yarn is available"
    else
      fail "yarn is not available"
    end
  end

  desc "check schedule.rb"
  task :check_schedule, :environment do
    if File.readable?(File.join(Rails.root, 'config', 'schedule.rb'))
      puts "schedule.rb is available"
    else
      fail "schedule.rb is not available"
    end
  end
end
