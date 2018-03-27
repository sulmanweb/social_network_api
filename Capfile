# Load DSL and set up stages
require 'capistrano/setup'
# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails/migrations'
require 'capistrano/rbenv'
# require 'capistrano/rvm'
require 'capistrano/rails/console'
require 'airbrussh/capistrano'
# require "whenever/capistrano"
require "capistrano/scm/git"
# require 'capistrano/sidekiq'
# require 'rollbar/capistrano3'
# require 'capistrano/sidekiq/monit' #to require monit tasks # Only for capistrano3
install_plugin Capistrano::SCM::Git
#
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.5.0'

# set :rvm_type, :user # or :system, depends on your rbenv setup
# set :rvm_ruby, '2.3.1'
# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each {|r| import r}
