namespace :installation do
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
end
