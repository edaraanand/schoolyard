set :application, "schoolapp"
set :user, "forge"
set :domain, "#{user}@schoolyardapp.com"
set :deploy_to, "/home/forge/#{application}"
set :repository,  "git@github.com:eshwardeep/schoolapp.git"
set :revision, "HEAD"
set :branch, "master"
set :adapter, "mongrel"
set :processes, 1
set :log_path, "#{shared_path}/log/production.log"

namespace :vlad do
    Rake.clear_tasks('vlad:start_app', 'vlad:migrate', 'vlad:update_symlinks')
    
   desc "Prepares application servers for deployment. merb
        configuration is set via the merb_* variables.".cleanup
   remote_task :setup_app, :roles => :app do
     "rake"
   end
   
   desc "Restart the app servers"
   remote_task :start_app, :roles => :app do
      run "merb -a #{adapter} -e production -c #{processes} -m #{current_path}/generic -L #{log_path}"
   end
   
   remote_task :start_app => :stop_app

   desc "Stop the app servers"
   remote_task :stop_app, :roles => :app do
     run "cd #{current_path} && merb -a #{adapter} -K all" 
   end
   
   desc "moving the database to some other place"
   remote_task :before_update, :roles => :app do
     run "mv #{current_path}/generic/db  /home/forge"
     run "mv #{current_path}/generic/public/uploads /home/forge"
   end
   
   desc "updates the code and changing symlink files"
   remote_task :update, :roles => :app do
      run "mv #{latest_release}/generic/config/database.yml.production #{current_path}/generic/config/database.yml"
      run "mv /home/forge/db  #{current_path}/generic" 
      run "mv /home/forge/uploads #{current_path}/generic/public"
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
      ######  Back up Code Start from Here  #######
      run "cd #{current_path}/generic && rake bootstrap:backup"
      run "scp #{current_path}/generic/db/schoolapp_production eshwar@sdb.schoolyardapp.net:/home/eshwar/backups/demo/db_#{Time.now.strftime("%Y%m%d%H%M%S")}"
      filename = "uploads_#{Time.now.strftime("%Y%m%d%H%M%S")}.tar"
      run "tar zcf /home/forge/sqlitebackupsdotcom/#{filename} #{current_path}/generic/public/uploads"
      run "scp -r /home/forge/sqlitebackupsdotcom/#{filename} eshwar@sdb.schoolyardapp.net:/home/eshwar/backups/demo"
      #### End of Back up Code ######      
      run "cd #{current_path}/generic && rake basecamp:notify_new_build"
   end
  
   desc "Full deployment cycle"
   remote_task :deploy, :roles => :app do
      Rake::Task['vlad:before_update'].invoke
      Rake::Task['vlad:update'].invoke
      Rake::Task['vlad:migrate'].invoke
      Rake::Task['vlad:start_app'].invoke
      Rake::Task['vlad:cleanup'].invoke
   end
  
end



