require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Boskop
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    unless Rails.env.test?
      config.active_job.queue_adapter = :good_job
      config.active_job.queue_name_prefix = "boskop_#{Rails.env}"
    end
    config.responders.error_status = :unprocessable_entity
    config.responders.redirect_status = :see_other
  end
end
