
set :application, 'rails6'
set :repo_url, 'git@github.com:codeglover/rails6.git'

set :use_sudo, false
set :deploy_via, :copy
set :keep_releases, 2

set :log_level, :debug
set :pty, false

# RVM 1 Settings
# append :rvm1_map_bins, 'rake', 'gem', 'bundle', 'ruby', 'puma', 'pumactl'
# set :rvm1_ruby_version, 'ruby-3.0.0'
# set :rvm_type, :user
# set :default_env, {
#     rvm_bin_path: '~/.rvm/bin',
# }
# set :rvm1_map_bins, %w{rake gem bundle ruby puma pumactl}


# RVM Settings
set :rvm_type, :user
set :rvm_ruby_version, '3.0.0'
# set :rvm_custom_path, '~/.rvm/bin'
set :default_env, {
    "RAILS_MASTER_KEY" => ENV["RAILS_MASTER_KEY"]
}

# set :linked_files, ['config/database.yml', 'config/master.key']
# append :linked_files, "config/master.key"

append :linked_dirs, ['.bundle', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'tmp/uploads/cache', 'tmp/uploads/store']
append :linked_files, 'config/database.yml', 'config/master.key'
# set :assets_dependencies, %w(app/assets lib/assets vendor/assets config/routes.rb)
# removed
# Gemfile.lock

#sidekiq
# set :init_system, :systemd
# set :service_unit_name, "sidekiq.service"
# set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
# set :sidekiq_log => File.join(shared_path, 'log', 'sidekiq.log')

# RAILS specific settings

# If the environment differs from the stage name
# set :rails_env, 'staging'

# Defaults to :db role
# App is recommended since the framework manages this
set :migration_role, :app

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Defaults to [:web]
set :assets_roles, [:web, :app]

# Defaults to 'assets'
# This should match config.assets.prefix in your rails config/application.rb
set :assets_prefix, 'prepackaged-assets'

# Defaults to ["/path/to/release_path/public/#{fetch(:assets_prefix)}/.sprockets-manifest*", "/path/to/release_path/public/#{fetch(:assets_prefix)}/manifest*.*"]
# This should match config.assets.manifest in your rails config/application.rb
set :assets_manifests, ['app/assets/config/manifest.js']

# RAILS_GROUPS env value for the assets:precompile task. Default to nil.
set :rails_assets_groups, :assets

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}


namespace :deploy do

  namespace :check do
    before :linked_files, :copy_linked_files_if_needed do
      on roles(:app), in: :sequence, wait: 10 do
        %w{master.key database.yml}.each do |config_filename|
          unless test("[ -f #{shared_path}/config/#{config_filename} ]")
            upload! "config/#{config_filename}", "#{shared_path}/config/#{config_filename}"
          end
        end
      end
    end
  end

  # namespace :check do
  #   before :linked_files, :set_master_key do
  #     on roles(:app), in: :sequence, wait: 10 do
  #       unless test("[ -f #{shared_path}/config/master.key ]")
  #         upload! 'config/master.key', "#{shared_path}/config/master.key"
  #       end
  #     end
  #   end
  # end

  # task :fix_absent_manifest_bug do
  #   on roles(:web) do
  #     within release_path do execute 'mkdir', release_path, 'assets_manifest_backup'
  #     end
  #   end
  # end
  #
  # after :updating, 'deploy:fix_absent_manifest_bug'




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
  #before :starting, 'deploy:fix_absent_manifest_bug'
  # desc 'create_db'
  # task :create_db do
  #   on roles(:app) do
  #     invoke 'rvm1:hook'
  #     within release_path do
  #       execute :bundle, :exec, :"rails db:create RAILS_ENV=#{fetch(:stage)}"
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
  #       execute :bundle, :exec, :"rails db:seed RAILS_ENV=#{fetch(:stage)}"
  #     end
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
  after :finished, 'puma:restart'
end

namespace :app do
  desc 'Start application'
  task :start do
    on roles(:app) do
      invoke 'rvm1:hook'
      within "#{fetch(:deploy_to)}/current/" do
        execute :bundle, :exec, :"puma -C config/puma.rb -e #{fetch(:stage)}"
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app) do
      invoke 'rvm1:hook'
      within "#{fetch(:deploy_to)}/current/" do
        execute :bundle, :exec, :'pumactl -F config/puma.rb stop'
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      invoke 'rvm1:hook'
      within "#{fetch(:deploy_to)}/current/" do
        if test("[ -f #{deploy_to}/current/tmp/pids/puma.pid ]")
          execute :bundle, :exec, :'pumactl -F config/puma.rb stop'
        end

        execute :bundle, :exec, :"puma -C config/puma.rb -e #{fetch(:stage)}"
      end
    end
  end
end