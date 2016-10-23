source 'https://rubygems.org'


gem 'rails', '~> 4.2.7'
gem 'pg'
gem 'postgres_ext'

gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '>= 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  	platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks', '~> 2.5.3'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem "bower-rails", "~> 0.11.0"

# gem 'bootstrap-sass' #, '~> 3.2.0'
gem 'jquery-ui-rails'
# gem 'jquery-datatables-rails'
# gem 'select2-rails'

gem 'simple_form'
gem 'wobauth', git: 'https://github.com/swobspace/wobauth.git', branch: '1-0-stable'
gem 'wobapphelpers', git: 'https://github.com/swobspace/wobapphelpers.git',
                     branch: '1-0-stable'
gem 'cancancan'
gem 'acts_as_list'
gem 'ancestry'
gem 'settingslogic'
gem 'devise-remote-user'
# gem 'devise-remote-user', git: 'https://github.com/swobspace/devise-remote-user.git',
#      branch: 'master'
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
  gem "shoulda", require: false
  gem 'factory_girl_rails'
  gem 'database_rewinder'
  gem "capybara"
  gem "poltergeist"
end

