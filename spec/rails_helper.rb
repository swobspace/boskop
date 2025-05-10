# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require 'shoulda/matchers'
require 'factory_bot_rails'
# require 'view_component/test_helpers'
require 'capybara/rspec'

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1280,1280")

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

# Capybara.javascript_driver = :selenium_chrome
# Capybara.javascript_driver = :selenium_chrome_headless
Capybara.javascript_driver = :chrome_headless
Capybara.disable_animation = true

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Capybara::DSL

  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # -- devise stuff
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.extend ControllerMacros, type: :controller
  config.extend ControllerMacros, type: :view
  config.include RequestMacros, type: :request
  config.include RequestMacros, type: :feature
  # config.include ViewComponent::TestHelpers, type: :component
  # config.include Capybara::RSpecMatchers, type: :component

  config.before(:suite) do
    DatabaseRewinder.clean_all
  end
  config.after(:each) do
    DatabaseRewinder.clean
  end

  # config.after(:suite) do
  #   ActiveStorage::Blob.unattached.each(&:purge)
  # end

end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
