set :application, "csd"
set :scm, "git"
set :repository,  "git@github.com:bjbolz/schoolapp.git"
set :use_sudo, false

set :deploy_to, "/home/niket/#{application}"
set :adapter, 'mongrel' # or 'thin' 
set :start_port, 9000 
set :processes, 1
set :log_path, "#{shared_path}/log/production.log"

role :app, "beta.insightmethods.com"
role :web, "beta.insightmethods.com"
role :db,  "beta.insightmethods.com", :primary => true


namespace :deploy do 
  desc "Change the database configuration file"
  task :after_update_code do
    run "mv #{release_path}/config/database.yml.production #{release_path}/config/database.yml"
  end
  
  desc "Start Merb Instances"  
  task :start do 
    run "merb -a #{adapter} -e production -c #{processes} --port #{start_port} -m #{current_path} -L #{log_path}"  
  end 
 
  desc "Stop Merb Instances"  
  task :stop do 
    run "cd #{current_path} && merb -a #{adapter} -k all"  
  end 
 
  desc 'Custom restart task for Merb' 
  task :restart, :roles => :app do 
    deploy.stop 
    deploy.start 
  end 
end