# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "bag_umbala"
set :repo_url, ENV['GIT']

# Default branch is :master
set :branch, 'master'
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_root, '/home/deploy'
set :deploy_to, "#{fetch(:deploy_root)}/bag-umbala"
set :deploy_via, :remote_cache
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh
set :format, :pretty

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true
set :ssh_options, {:forward_agent => true}
# default_run_options[:pty] = true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

require 'capistrano/rvm'
set :rails_env, 'production'
set :rvm_type, :user
set :rvm_ruby_version, '2.2.2'
set :default_env, {rvm_bin_path: "~/.rvm/bin"}
set :environment, "production"

require 'sshkit'
# SSHKit.config.default_env = { BAG_UMBALA_DATABASE_USERNAME: '. $HOME/.bash_profile; echo $BAG_UMBALA_DATABASE_USERNAME' }

# bundler
require "capistrano/bundler"

puts "shared_path: #{shared_path}"
puts "release_path: #{release_path}"
puts "env: #{ENV['BAG_UMBALA_DATABASE_USERNAME']}"

set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, ''
set :bundle_without, %w{test development}.join(' ')
set :bundle_binstubs, -> { release_path.join('bin') }
set :bundle_roles, :all

set :stages, ["staging", "production"] # importance
set :default_stage, "production" # importance
set :assets_roles, [:web, :app]
set :rails_assets_groups, :assets
# set :instance_id, "i-082f935ffdf336ce0"

# set :file_socket, "unicorn.qlxekhachGT.sock"

# Default value for keep_releases is 5
set :keep_releases, 5

# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

desc 'Test Task'
task :test do
  on roles(:db) do
    puts "bundle_gemfile: #{fetch(:bundle_gemfile)}"
    puts "bundle_binstubs: #{fetch(:bundle_binstubs)}"

    # run "#{sudo} echo 'Hello World' > ~/hello"

    # execute("cd #{deploy_to}/current && ~/.rvm/bin/rvm 2.2.2 do bundle exec rake seo:sitemap")
    # split 2 row is error "Could not locate Gemfile or .bundle/ directory"
    # execute("cd #{deploy_to}/current")
    # execute("~/.rvm/bin/rvm 2.2.2 do bundle exec rake seo:sitemap")
  end
end

# gem https://github.com/tablexi/capistrano3-unicorn
set :shared_dir, "#{release_path}/shared"
set :unicorn_pid, "#{fetch(:shared_dir)}/pids/unicorn.pid"
# set :pid, "`cat /home/deploy/bag-umbala/current/shared/pids/unicorn.pid`"
set :unicorn_config_path , "config/unicorn.rb"
# set :use_sudo, false
set :default_env, {
    # 'BAG_UMBALA_DATABASE_USERNAME' => '. $HOME/.bash_profile; echo $BAG_UMBALA_DATABASE_USERNAME'
    'PHUONG_HENG_DATABASE_HOST' => ENV['PHUONG_HENG_DATABASE_HOST'],
    'BAG_UMBALA_DATABASE_USERNAME' => ENV['BAG_UMBALA_DATABASE_USERNAME'],
    'BAG_UMBALA_DATABASE_PASSWORD' => ENV['BAG_UMBALA_DATABASE_PASSWORD'],
    'SECRET_KEY_BASE_BAG_UMBALA' => ENV['SECRET_KEY_BASE_BAG_UMBALA'],
    'DEVISE_SECRET_KEY_BAG_UMBALA' => ENV['DEVISE_SECRET_KEY_BAG_UMBALA'],
    'BACKUP_QLXEKHACH_S3_ACCESS_KEY_ID' => ENV['BACKUP_QLXEKHACH_S3_ACCESS_KEY_ID'],
    'BACKUP_QLXEKHACH_SECRET_ACCESS_KEY' => ENV['BACKUP_QLXEKHACH_SECRET_ACCESS_KEY']
    # 'LENGTH_SUBDOMAIN' => ENV['LENGTH_SUBDOMAIN']
}

# Thiết lập các chỉ dẫn sau khi deploy tại đây
# Sau khi kết thúc việc deploy, Capistrano sẽ
# thực hiện các lệnh ở dưới.
namespace :deploy do
  # desc 'DB Setup'
  # task :db_setup do
  #   on roles(:app), in: :sequence, wait: 10 do
  #     puts "<---DB Setup---"
  #     within release_path do
  #       with rails_env: fetch(:rails_env) do
  #         execute :rake, 'db:setup'
  #         execute :rake, 'db:seed'
  #         # execute :rake, 'db:migrate'
  #       end
  #     end
  #     puts "---DB Setup--->"
  #   end
  # end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 10 do
      puts "<---Restart application---"
      within release_path do
        with rails_env: fetch(:rails_env) do
          invoke 'unicorn:legacy_restart'
          sleep 3
          execute "sudo service unicorn_#{fetch(:application)} restart"
          sleep 6
          execute "sudo service unicorn_#{fetch(:application)} restart"
          # sleep 5
          # puts "whats running now, eh unicorn?"
          # execute "ps aux | grep unicorn"

          # on roles(:app) do |host|
          #   # execute :sudo, '/etc/init.d/nginx restart'
          #   # execute :sudo, "/etc/init.d/unicorn_#{fetch(:application)} restart"
          #   execute :sudo, "service unicorn_#{fetch(:application)} restart"
          #   # execute :sudo, "aws ec2 reboot-instances --instance-ids #{fetch(:instance_id)}"
          # end

          # as :app  do
          #   execute "#{fetch(:sudo)} /etc/init.d/unicorn_#{fetch(:application)} restart"
          #   execute "#{fetch(:sudo)} /etc/init.d/nginx restart"
          # end

          # on roles(:all) do
          #   execute "#{fetch(:sudo)} service unicorn_#{fetch(:application)} restart"
          # end
          # run "#{sudo} service unicorn_#{fetch(:application)} start", { :shell => 'bash'}
        end
      end
      puts "---Restart application--->"
    end
  end

  # %w( start stop restart ).each do |command|
  #   desc "#{command} unicorn server"
  #   task command, roles: :app, except: {no_release: true} do
  #     run "/etc/init.d/unicorn_#{application} #{command}"
  #   end
  # end

  desc "Prepare for Unicorn"
  task :prepare_for_unicorn do
    on roles(:app), in: :groups do
      puts "<---Prepare for Unicorn---"

      # within release_path do
      #   with rails_env: fetch(:rails_env) do
      #     execute "rm -rf shared/pids shared/sockets shared/log"
      #     execute "cd #{release_path} && mkdir -p shared/pids shared/sockets shared/log"
      #     # invoke 'deploy:start_unicorn'
      #     invoke 'unicorn:restart'
      #   end
      # end

      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "cd #{fetch(:deploy_to)} && mkdir -p shared/pids shared/sockets shared/log"
          execute "ln -nfs #{fetch(:deploy_to)}/shared #{release_path}/shared"
          # invoke 'unicorn:restart'
        end
      end

      puts "---Prepare for Unicorn--->"
    end
  end

  desc "Symlink Shared"
  task :symlink_shared do
    puts "<---Symlink Shared---"
    on roles(:app), in: :groups do
      execute "rm -rf #{release_path}/app/store_module_general #{release_path}/app/store_module_private #{release_path}/app/store_module_using"
      execute "ln -nfs #{fetch(:shared_dir)}/store_module_general #{release_path}/app/store_module_general"
      execute "ln -nfs #{fetch(:shared_dir)}/store_module_private #{release_path}/app/store_module_private"
      execute "ln -nfs #{fetch(:shared_dir)}/store_module_using #{release_path}/app/store_module_using"

      execute "rm -rf #{release_path}/public/uploads"
      execute "ln -nfs #{fetch(:shared_dir)}/uploads #{release_path}/public/uploads"
      execute "ln -nfs #{fetch(:shared_dir)}/log/my_log4r.log #{release_path}/my_log4r.log"
    end
    puts "---Symlink Shared--->"
  end

  desc "Update the crontab file"
  task :update_crontab do
    puts "<---Update Crontab---"
    on roles(:app), in: :groups do
      within release_path do
        execute :bundle, :exec, :"whenever --update-crontab #{fetch(:application)}"
      end
    end
    puts "---Update Crontab--->"
  end

  desc "Prepare Seo File and Unicorn, then restart service"
  after :publishing, :prepare do
    on roles(:app), in: :groups do
      puts "<---Prepare Seo File and Unicorn, then restart service---"

      within release_path do
        with rails_env: fetch(:rails_env) do
          # execute :rake, 'seo:sitemap'
          # execute :rake, "permissions:load_permissions"
          # invoke "deploy:update_crontab"
          invoke "deploy:symlink_shared"
          invoke "deploy:prepare_for_unicorn"
          invoke "deploy:restart"
        end
      end

      puts "---Prepare Seo File and Unicorn, then restart service--->"
    end
  end

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     within release_path do
  #       # execute :rake, 'cache:clear'
  #       execute :rake, 'tmp:cache:clear'
  #     end
  #   end
  # end
end