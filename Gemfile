source 'https://rubygems.org'


gem 'rails', '~> 7.2.0'
gem 'rails-i18n', '~> 7.0'
gem 'pg'

gem 'jbuilder', '~> 2.0'
# gem 'font-awesome-sass', '~> 5.0'

gem "sprockets-rails"
# gem 'coffee-rails'
gem "turbo-rails"
gem "jsbundling-rails"
gem "cssbundling-rails"
gem "stimulus-rails"

gem 'simple_form'
gem 'wobaduser', '~> 1.0'
gem 'wobapphelpers', git: 'https://github.com/swobspace/wobapphelpers', branch: 'master'
gem 'wobauth', git: 'https://github.com/swobspace/wobauth.git', branch: 'master'
gem 'cancancan'
gem 'acts_as_list'
gem 'ancestry'
gem 'devise-remote-user'

gem 'yaml_db'
group :development do
  gem 'puma'
  gem 'guard'
  gem "guard-rspec", require: false
  gem "capistrano", '~> 3.17'
  gem "capistrano-rails", '~> 1.1'
  gem 'capistrano-passenger'
  gem 'capistrano-yarn'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'licensed'
end

group :test, :development do
  gem 'rspec-rails', '>= 4.0.0'
  gem 'dotenv'
  gem 'json_spec', require: false
end

group :test do
  gem "shoulda-matchers", require: false
  gem 'factory_bot_rails'
  gem 'database_rewinder', git: 'https://github.com/amatsuda/database_rewinder', branch: :master
  gem "capybara"
  gem 'selenium-webdriver'
  gem 'webdriver'
  gem 'launchy'
end

gem 'record_tag_helper', '~> 1.0'
gem 'rails-controller-testing'
gem 'daemons'
gem "ruby-nmap", '>= 1.0.1'
gem 'immutable-struct'
gem 'kaminari'
gem 'tenable-ruby'
gem 'whenever'
gem 'gelf'
gem 'bootsnap', require: false
gem 'exception_notification'
gem 'rubyzip', '>= 1.3.0'
gem 'responders'

# for deployment
gem "ed25519"
gem "bcrypt_pbkdf"

gem "mail"

# Use Redis for Action Cable
gem 'redis'

gem "good_job", "~> 4.7.0"
