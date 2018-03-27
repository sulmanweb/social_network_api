lock '3.10.1'

set :application, 'social_network_api'
set :repo_url, 'git@github.com:sulmanweb/social_network_api.git'
# Default value for :format is :airbrussh.
set :format, :airbrussh

set :keep_releases, 1
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/dist}
set :linked_files, %w{config/database.yml config/secrets.yml config/cable.yml config/application.yml}
set :bundle_binstubs, -> {shared_path.join('bin')}
set :stages, %w[production]
set :default_stage, 'production'
# set :sidekiq_options_per_process, ["--queue high", "--queue default --queue low"]
# set :sidekiq_default_hooks, true
# set :sidekiq_role, :app
# set :sidekiq_config, -> {File.join(current_path, 'config', 'sidekiq.yml')}
# set :sidekiq_options, "-q default -q mailers"
# set :pty, false
set :rbenv_map_bins, %w(rake gem bundle ruby rails) # sidekiq sidekiqctl)
# set :whenever_identifier, -> {"#{fetch(:application)}_#{fetch(:stage)}"}

def tag_branch_target
  tags = `git tag`.split("\n")
  tag_prompt = "\nlast tags available are #{tags.reverse[(0..5)]}"
  ask :branch_or_tag, tag_prompt
  tag = fetch(:branch_or_tag)
  tag.match(/^\d/).nil? ? tags.last : tag
end


set :branch, proc {tag_branch_target}
# set :branch, 'master'
# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  desc 'Runs rake db:seed'
  task :seed => [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rails, "db:seed"
        end
      end
    end
  end

  # task :add_default_hooks do
  #   after 'deploy:starting', 'sidekiq:quiet'
  #   after 'deploy:updated', 'sidekiq:stop'
  #   after 'deploy:reverted', 'sidekiq:stop'
  #   after 'deploy:published', 'sidekiq:start'
  # end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
