set :application, "schoolapp"
set :scm, "git"
set :repository,  "git@github.com:eshwardeep/schoolapp.git"
set :revision, "HEAD"
set :use_sudo, false
set :scm_passphrase, 'eshwar'
set :branch, 'master'
set :deploy_via, :remote_cache

default_run_options[:pty] = true
set :ssh_options, { :forward_agent => true }
#set :user, 'deployer'

set :domain,   "eshwar@sdb.schoolyardapp.net"
set :deploy_to,  "/home/eshwar/schoolapp"
set :adapter, 'mongrel' # or 'thin' 
set :start_port, 7001
set :processes, 1
set :log_path, "#{shared_path}/log/production.log"

role :app, "sdb.schoolyardapp.net"
role :web, "sdb.schoolyardapp.net"
role :db,  "sdb.schoolyardapp.net", :primary => true


namespace :deploy do 
  
  # # desc "Copying the database to somewhere"
   #task :before_update do
   #  run "mv #{current_path}/generic/db  /home/eshwar"
  #end
  
  desc "Change the database configuration file"
  task :after_update do
	   run "mv #{current_path}/generic/config/database.yml.production #{current_path}/generic/config/database.yml"
	   run "rm -fr #{current_path}/generic/db"
    # run "mv /home/eshwar/db  #{current_path}/generic"   
     run "mkdir -p #{current_path}/generic/db"
     run "cp #{current_path}/generic/lib/constantz.rb.sample #{current_path}/generic/lib/constantz.rb"
     run "cd #{current_path}/generic && rake db:migrate VERSION=0 MERB_ENV=production"
	   run "cd #{current_path}/generic && rake db:migrate MERB_ENV=production"
     run "cd #{current_path}/generic && rake bootstrap:alerts"   
     run "cd #{current_path}/generic && rake school2:person"
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

