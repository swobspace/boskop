source 'https://rubygems.org'


gem 'rails', '~> 5.1.0'
gem 'rails-i18n', '~> 5.0.0' # For 5.0.x and 5.1.x
gem 'pg'

gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '>= 4.0.0'
gem 'therubyracer',  	platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem "bower-rails", "~> 0.11.0"

gem 'jquery-ui-rails'

gem 'simple_form'
gem 'wobauth', git: 'https://github.com/swobspace/wobauth.git', branch: 'master'
gem 'wobapphelpers', git: 'https://github.com/swobspace/wobapphelpers.git',
                     branch: 'master'
gem 'cancancan'
gem 'acts_as_list'
gem 'ancestry'
gem 'settingslogic'
gem 'devise-remote-user'
gem 'data-confirm-modal', git: 'https://github.com/ifad/data-confirm-modal.git'

gem 'yaml_db'
group :development do
  gem 'puma'
  gem 'spring'
  gem 'guard'
  gem "guard-livereload", require: false
  gem 'guard-rails'
  gem 'guard-bundler'
  gem "guard-rspec", require: false
  gem "capistrano", '~> 3.6'
  gem "capistrano-rails", '~> 1.1'
  gem 'capistrano-passenger'
  gem "railroady"
  gem "better_errors"
  gem "binding_of_caller"
  gem "meta_request"
end

group :test, :development do
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
  gem 'dotenv'
end

group :test do
  # gem "shoulda-matchers", require: false, git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem "shoulda-matchers", require: false
  gem 'factory_girl_rails'
  gem 'database_rewinder'
  gem "capybara"
  gem "poltergeist"
end

gem 'record_tag_helper', '~> 1.0'
gem 'rails-controller-testing'
