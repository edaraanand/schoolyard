set :application, "schoolapp"
set :scm, "git"
set :repository,  "git@github.com:bjbolz/schoolapp.git"
set :use_sudo, false

set :deploy_to, "/home/niket/#{application}"
set :adapter, 'mongrel' # or 'thin' 
set :start_port, 7001
set :processes, 1
set :log_path, "#{shared_path}/log/production.log"

role :app, "beta.insightmethods.com"
role :web, "beta.insightmethods.com"
role :db,  "beta.insightmethods.com", :primary => true


namespace :deploy do 
  
  desc "Change the database configuration file"
  task :after_update do
	  run "mv #{current_path}/generic/config/database.yml.production #{current_path}/generic/config/database.yml"
	  run "rm -fr #{current_path}/generic/db"
	  run "mkdir -p #{current_path}/generic/db"
	  run "cp #{current_path}/generic/lib/constantz.rb.sample #{current_path}/generic/lib/constantz.rb"
	  run "cd #{current_path}/generic && rake db:migrate MERB_ENV=production"
	  run "cd #{current_path}/generic && rake bootstrap:app"
  end
  
  desc "Start Merb Instances"  
  task :start do 
	  run "merb -a #{adapter} -e production -c #{processes} --port #{start_port} -m #{current_path}/generic -L #{log_path}"  
  end
 
  desc "Stop Merb Instances"  
  task :stop do 
    run "cd #{current_path} && merb -a #{adapter} -K all"  
  end 
 
  desc "Custom restart task for Merb"
  task :restart, :roles => :app do 
    deploy.stop 
    deploy.start 
  end 
  
end
