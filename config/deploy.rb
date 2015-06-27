# coding: utf-8
# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'checkin'
set :repo_url, 'https://github.com/CMUPreCollege/CheckIn.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/srv/rails/#{fetch :application}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Bundler options
set :bundle_flags, '--deployment --local'


#
# Retrieve Host Uptime
#
desc "Report uptimes"
task :uptime do
  on roles(:all), in: :parallel do |host|
    uptime = capture(:uptime)
    puts "#{host.hostname} reports: #{uptime}"
  end
end


#
# Assorted Utility Tasks for Deploy
#
namespace :deploy do

  desc "Update RVM key"
  task :update_rvm_key do
    on roles(:all) do |host|
      execute :gpg, "--keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3"
    end
  end
  before "rvm1:install:rvm", "deploy:update_rvm_key"
  
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

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

before 'deploy', 'rvm1:install:rvm'
before 'deploy', 'rvm1:install:ruby'

before 'bundler:install', 'rvm1:hook'


#
# Database Tasks
#
namespace :db do

  desc 'Setup database'
  task :setup do
    on roles(:db) do
      within release_path do
        with rails_env: (fetch(:rails_env) || fetch(:stage)) do
          execute :rake, 'db:setup'
        end
      end
    end
  end

end

before 'db:setup', 'deploy:updating'


#
# Rails Console & DB Console Support
#
# http://www.webascender.com/Blog/ID/577/Starting-a-Remote-Rails-Console-With-Capistrano
namespace :rails do
  desc "Remote console"
  task :console do
    on roles(:app) do |h|
      run_interactively "bundle exec rails console #{fetch(:rails_env)}", h.user
    end
  end

  desc "Remote dbconsole"
  task :dbconsole do
    on roles(:app) do |h|
      run_interactively "bundle exec rails dbconsole #{fetch(:rails_env)}", h.user
    end
  end

  def run_interactively(command, user)
    info "Running `#{command}` as #{user}@#{host}"
    exec %Q(ssh #{user}@#{host} -t "bash --login -c 'cd #{fetch(:deploy_to)}/current && #{command}'")
  end
end
