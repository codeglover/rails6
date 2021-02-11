
set :application, 'rails6'
set :repo_url, 'git@github.com:codeglover/rails6.git'

set :use_sudo, false
set :deploy_via, :copy
set :keep_releases, 2

set :log_level, :debug
set :pty, false

# RVM 1 Settings
# append :rvm1_map_bins, 'rake', 'gem', 'bundle', 'ruby', 'puma', 'pumactcl'
set :rvm1_ruby_version, 'ruby-3.0.0'
set :rvm_type, :user
set :default_env, {
    rvm_bin_path: '~/.rvm/bin',
}
set :rvm1_map_bins, %w{rake gem bundle ruby puma pumactl}


# RVM Settings
# set :rvm_type, :user
# set :rvm_ruby_version, '3.0.0'
# set :rvm_custom_path, '~/.rvm/bin'
# set :default_env, {
#     "RAILS_MASTER_KEY" => ENV["RAILS_MASTER_KEY"]
# }



# set :linked_files, ['config/database.yml', 'config/master.key']
# append :linked_files, "config/master.key"

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'
append :linked_files, 'config/database.yml', 'config/master.key'
set :assets_dependencies, %w(app/assets lib/assets vendor/assets config/routes.rb)
# removed
# Gemfile.lock

#sidekiq
# set :init_system, :systemd
# set :service_unit_name, "sidekiq.service"
# set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
# set :sidekiq_log => File.join(shared_path, 'log', 'sidekiq.log')

set :default_env, {
    "RAILS_ENV" => "production",
    "RAILS_MASTER_KEY" => "0fc7ba1b4e9b96b4d793aa7ada0387a4",
    "PATH" => "/home/ubuntu/.nvm/versions/node/v15.8.0/bin:$PATH"
}

namespace :deploy do

  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end
  end

  # namespace :assets do
  #   task :backup_manifest do
  #     on roles(fetch(:assets_roles)) do
  #       within release_path do
  #         execute :cp,
  #                 release_path.join('public', fetch(:assets_prefix), '.sprockets-manifest*'),
  #                 release_path.join('assets_manifest_backup')
  #       end
  #     end
  #   end
  # end
  # desc 'Uploads required config files'
  # task :upload_configs do
  #   on roles(:all) do
  #     upload!(".env.#{fetch(:stage)}", "#{deploy_to}/shared/.env")
  #   end
  # end
  # desc 'Seeds database'
  # task :seed do
  #   on roles(:app) do
  #     invoke 'rvm1:hook'
  #     within release_path do
  #       execute :bundle, :exec, :"rake db:setup RAILS_ENV=#{fetch(:stage)}"
  #     end
  #   end
  # end

  # before 'deploy:migrate', 'deploy:create_db'
  # after :finished, 'deploy:seed'
  # after :finished, 'app:restart'
  # after :finished, 'puma:restart'
end

# namespace :app do
#   desc 'Start application'
#   task :start do
#     on roles(:app) do
#       invoke 'rvm1:hook'
#       within "#{fetch(:deploy_to)}/current/" do
#         execute :bundle, :exec, :"puma -C config/puma.rb -e #{fetch(:stage)}"
#       end
#     end
#   end
#
#   desc 'Stop application'
#   task :stop do
#     on roles(:app) do
#       invoke 'rvm1:hook'
#       within "#{fetch(:deploy_to)}/current/" do
#         execute :bundle, :exec, :'pumactl -F config/puma.rb stop'
#       end
#     end
#   end
#
#   desc 'Restart application'
#   task :restart do
#     on roles(:app) do
#       invoke 'rvm1:hook'
#       within "#{fetch(:deploy_to)}/current/" do
#         if test("[ -f #{deploy_to}/current/tmp/pids/puma.pid ]")
#           execute :bundle, :exec, :'pumactl -F config/puma.rb stop'
#         end
#
#         execute :bundle, :exec, :"puma -C config/puma.rb -e #{fetch(:stage)}"
#       end
#     end
#   end
# end