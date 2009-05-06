set :domain, "forge@schoolyardapp.com"
set :deploy_to, "/home/forge/schoolapp"
set :repository,  "git@github.com:eshwardeep/schoolapp.git"
set :branch, 'master'
set :start_port, 7001
set :adapter, 'mongrel'
set :processes, 1



namespace :vlad do
  
     desc 'Runs vlad:update, vlad:symlink, vlad:migrate and vlad:start'
     task :deploy => ['vlad:update', 'vlad:symlink', 'vlad:migrate', 'vlad:stop_app', 'vlad:start_app']
     
     desc 'Symlinks your custom directories'
     remote_task :symlink, :roles => :app do
       run "ln -s #{shared_path}/database.yml #{current_release}/config/database.yml"
     end
     
end



