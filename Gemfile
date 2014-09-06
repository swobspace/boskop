source 'https://rubygems.org'


gem 'rails', '~> 4.1.0'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer',  	platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bootstrap-sass', '~> 3.2.0'
gem 'jquery-ui-rails'
gem 'jquery-datatables-rails'

gem 'simple_form', git: 'https://github.com/plataformatec/simple_form.git',
                   branch: 'master'
gem 'wobauth', git: 'https://github.com/swobspace/wobauth.git', branch: 'master'
gem 'wobapphelpers', git: 'https://github.com/swobspace/wobapphelpers.git',
                     branch: "master"
gem 'cancancan', '~> 1.9.0'

group :development do
  gem 'thin'
  gem 'spring'
  gem 'guard'
  gem "guard-livereload", require: false
  gem 'guard-rails'
  gem 'guard-bundler'
  gem "guard-rspec", require: false
  gem "capistrano-rails", '~> 1.1.1'
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

