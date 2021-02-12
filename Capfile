require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/setup'
require 'capistrano/deploy'

# require 'capistrano/rvm'
require 'rvm1/capistrano3'

require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/faster_assets'
require 'capistrano/postgresql'
# require 'capistrano/sidekiq'
require 'capistrano/rails/console'
require 'capistrano/rails/logs'
# require 'capistrano/figaro_yml'

# require 'capistrano/npm'
# require 'capistrano/yarn'

require 'capistrano/puma'
install_plugin Capistrano::Puma


# install_plugin Capistrano::Puma::Systemd
# install_plugin Capistrano::Puma::Workers  # if you want to control the workers (in cluster mode)
# install_plugin Capistrano::Puma::Jungle # if you need the jungle tasks
# install_plugin Capistrano::Puma::Monit  # if you need the monit tasks
# install_plugin Capistrano::Puma::Nginx  # if you want to upload a nginx site template
# require 'capistrano/dotenv/tasks'
# require 'capistrano/sidekiq/monit' #to require monit tasks # Only for capistrano3
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
