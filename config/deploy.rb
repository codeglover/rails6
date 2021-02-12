
set :application, 'rails6'
set :repo_url, 'git@github.com:codeglover/rails6.git'

set :use_sudo, false
set :deploy_via, :copy
set :keep_releases, 2

set :log_level, :debug
set :pty, false


# RVM 1 Settings
append :rvm1_map_bins, 'rake', 'gem', 'bundle', 'ruby', 'puma', 'pumactl'
set :rvm1_ruby_version, 'ruby-3.0.0'
set :rvm_type, :user
set :default_env, {
    rvm_bin_path: '~/.rvm/bin',
    path: '/home/ubuntu/.nvm/versions/node/v14.4.0/bin'
}
set :rvm1_map_bins, %w{rake gem bundle ruby puma pumactl}

# RVM Settings
# set :rvm_type, :user
# set :rvm_ruby_version, '2.3.3'
# set :rvm_custom_path, '~/.myveryownrvm'

set :linked_files, ['config/database.yml', 'config/master.key']
set :linked_dirs, ['log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'tmp/uploads/cache', 'tmp/uploads/store']

set :assets_dependencies, %w(app/assets lib/assets vendor/assets config/routes.rb)
# removed
# Gemfile.lock

#sidekiq
set :init_system, :systemd
set :service_unit_name, "sidekiq.service"
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
set :sidekiq_log => File.join(shared_path, 'log', 'sidekiq.log')

# yarn

# default not set
# set :yarn_target_path, -> { "/home/ubuntu/.nvm/versions/node/v14.4.0/bin/yarn" }
# set :yarn_flags, '--silent --no-progress'    # default
# #set :yarn_flags, '--production --silent --no-progress'    # default
# set :yarn_roles, :all                                     # default
# set :yarn_env_variables, {}                               # default
# set :npm_target_path, -> { '/home/ubuntu/.nvm/versions/node/v14.4.0/bin' } # default not set
# set :npm_flags, '--production --silent --no-progress'    # default
# set :npm_roles, :all                                     # default
# set :npm_env_variables, {}                               # default
# set :npm_method, 'ci'                               # default
#
# set :yarn_target_path, -> { '/home/ubuntu/.nvm/versions/node/v14.4.0/bin' } # default not set
# set :yarn_flags, '--production'                           # default
# set :yarn_roles, :all                                     # default
# set :yarn_env_variables, {}

namespace :deploy do

  # task :fix_absent_manifest_bug do
  #   on roles(:web) do
  #     within release_path do execute 'mkdir', release_path, 'assets_manifest_backup'
  #     end
  #   end
  # end
  #
  # after :updating, 'deploy:fix_absent_manifest_bug'




  namespace :assets do
    task :backup_manifest do
      on roles(fetch(:assets_roles)) do
        within release_path do
          execute :cp,
                  release_path.join('public', fetch(:assets_prefix), '.sprockets-manifest*'),
                  release_path.join('assets_manifest_backup')
        end
      end
    end
  end
  # before "deploy:assets:precompile", "deploy:npm_install"
  #
  # namespace :deploy do
  #   desc 'Run rake npm install'
  #   task :npm_install do
  #     on roles(:web) do
  #       within release_path do
  #         execute("cd #{release_path} && npm install")
  #       end
  #     end
  #   end
  # end
  # before "deploy:assets:precompile", "deploy:yarn_install"
  #
  # namespace :deploy do
  #   desc 'Run rake yarn:install'
  #   task :yarn_install do
  #     on roles(:web) do
  #       within release_path do
  #         execute("cd #{release_path} && yarn install")
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

  desc 'Uploads required config files'
  task :upload_configs do
    on roles(:all) do
      upload!(".env.#{fetch(:stage)}", "#{deploy_to}/shared/.env")
    end
  end

  # desc 'Seeds database'
  # task :seed do
  #   on roles(:app) do
  #     invoke 'rvm1:hook'
  #     within release_path do
  #       execute :bundle, :exec, :"rails db:seed RAILS_ENV=#{fetch(:stage)}"
  #     end
  #   end
  # end

  desc 'Seeds database'
  task :seed do
    on roles(:app) do
      invoke 'rvm1:hook'
      within release_path do
        execute :bundle, :exec, :"rake db:setup RAILS_ENV=#{fetch(:stage)}"
      end
    end
  end

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