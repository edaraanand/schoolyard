set :domain, "forge@schoolyardapp.com"
set :deploy_to, "/home/forge"
set :repository,  "git@github.com:eshwardeep/schoolapp.git"
set :revision, "HEAD"



namespace :vlad do
  
   desc "Change the database configuration file"
   remote_task :after_update do
      run "mv #{current_path}/generic/config/database.yml.production #{current_path}/generic/config/database.yml"
      run "mkdir -p #{current_path}/generic/db"
      run "cp #{current_path}/generic/lib/constantz.rb.sample #{current_path}/generic/lib/constantz.rb"
      run "cd #{current_path}/generic && rake db:migrate MERB_ENV=production"
      run "cd #{current_path}/generic && rake bootstrap:alerts"
      run "cd #{current_path}/generic && rake contact:school"
      run "cd #{current_path}/generic && rake admin:person"
   end
    
   desc "Start Merb Instances"  
   remote_task :start do 
	    run "merb -m #{deploy_to}/current -e production -c #{processes} --port #{start_port} -m #{current_path}/generic -L #{log_path}"  
   end
   
   desc "Stop Merb Instances"
   remote_task :stop do
      run "merb -m #{deploy_to}/current -K all"
   end
   
     
end
