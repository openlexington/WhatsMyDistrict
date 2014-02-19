lock '3.1.0'
set :application, 'whatsmydistrict'
set :repo_url, 'https://github.com/openlexington/WhatsMyDistrict.git'
set :linked_dirs, %w{log tmp/pids tmp/sockets}
set :linked_files, %w{models/database_model.rb}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
