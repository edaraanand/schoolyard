set :application, "schoolapp"
set :user, "forge"
set :domain, "#{user}@schoolyardapp.com"
set :deploy_to, "/home/forge/#{application}"
set :repository,  "git@github.com:eshwardeep/schoolapp.git"
set :revision, "HEAD"
set :branch, "master"


namespace :vlad do
    Rake.clear_tasks('vlad:start_app', 'vlad:migrate', 'vlad:update_symlinks')
    
# # Merb app server
## set :merb_address,       "127.0.0.1"
# #set :merb_clean,         false
# set :merb_command,       'merb'
# set :merb_conf,          nil
# set :merb_extra_config,  nil
# set :merb_environment,   "production"
# set :merb_group,         nil
# set :merb_port,          7001
# set :merb_prefix,        nil
# set :merb_servers,       1
# set :merb_user,          nil
  
   desc "Prepares application servers for deployment. merb
        configuration is set via the merb_* variables.".cleanup

   remote_task :setup_app, :roles => :app do
     "rake"
   end
   
  # def merb(cmd) # :nodoc:
  #   "cd #{current_path} && #{merb_command} -p #{merb_port} -c #{merb_servers} -e #{merb_environment} #{cmd}"
  # end
   
   desc "Restart the app servers"
   
   remote_task :start_app, :roles => :app do
     run merb('')
   end
   
   remote_task :start_app => :stop_app

   desc "Stop the app servers"
   remote_task :stop_app, :roles => :app do
     run merb("-K all")
   end
   
   desc "updates the code and changing symlink files"
   remote_task :update, :roles => :app do
      run "mkdir -p #{current_path}/generic/db"
      run "mv #{latest_release}/generic/config/database.yml.production #{current_path}/generic/config/database.yml"
      run "cp #{latest_release}/generic/lib/constantz.rb.sample #{current_path}/generic/lib/constantz.rb"
   end
   
   desc "Symlink configuration".cleanup
   remote_task :update_symlinks, :roles => :app do
     run [ "ln -s #{shared_path}/log #{latest_release}/log",
           "ln -s #{shared_path}/system #{latest_release}/generic/public/system",
           "ln -s #{shared_path}/pids #{latest_release}/tmp/pids" ].join(" && ")
   end
   
   desc "Running migrations with some rake tasks for production"
   remote_task :migrate, :roles => :app do
      run "cd #{current_path}/generic && rake db:migrate MERB_ENV=production"
      run "cd #{current_path}/generic && rake bootstrap:alerts"
      run "cd #{current_path}/generic && rake contact:school"
      run "cd #{current_path}/generic && rake admin:person"
   end
  
   desc "Full deployment cycle"
   remote_task :deploy, :roles => :app do
      Rake::Task['vlad:update'].invoke
      Rake::Task['vlad:migrate'].invoke
      Rake::Task['vlad:start_app'].invoke
      Rake::Task['vlad:cleanup'].invoke
   end
  
end



