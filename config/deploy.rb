# config valid only for current version of Capistrano
lock '~>3.13.0'

config = YAML.load_file('config/deploy-config.yml') || {}

set :application, 'boskop'
set :repo_url, config['repo_url']
set :relative_url_root, config['relative_url_root'] || '/'
set :ruby_path, config['ruby_path']
set :passenger_restart_with_touch, true

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
ask :branch, :master

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'
set :deploy_to, config['deploy_to']

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/boskop.yml", "config/secrets.yml", "config/ldap.yml", "config/schedule.rb"

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
append :linked_dirs, "log", "files", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "node_modules"


# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, {
  rails_relative_url_root: fetch(:relative_url_root) ,
  path: fetch(:ruby_path) { "$PATH" }
}

set :shell, "bash -l"

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :check do
  desc "Check that we can access everything"
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end

  desc "check configuration and installation"
  task :configinstall do
    on roles(:app, :web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'installation:all'
        end
      end
    end
  end

  desc "printenv"
  task :printenv do
    on roles(:all) do |host|
      execute "printenv"
    end
  end
end

# before 'deploy:compile_assets', 'bower:install'
after 'deploy:symlink:release', 'check:configinstall'

