# return if Rails.env.test? || Rails.env.development? rescue nil
#
# app_path = '/home/ubuntu/www/rails6'
#
# directory "#{app_path}/current"
# rackup "#{app_path}/current/config.ru"
# daemonize true
# pidfile "#{app_path}/shared/tmp/pids/puma.pid"
# state_path "#{app_path}/shared/tmp/puma.state"
# workers 2
# threads 5, 5
# bind "unix:#{app_path}/shared/tmp/sockets/puma.sock"
# preload_app!
# on_worker_boot do
#   # Valid on Rails 4.1+ using the `config/database.yml` method of setting `pool` size
#   ActiveRecord::Base.establish_connection
# end
#
