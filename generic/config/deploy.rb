set :application, "schoolapp"
set :scm, "git"
set :repository, "git@github.com:eshwardeep/schoolapp.git"
#set :revision, "HEAD"
set :branch, 'capistrano'
set :use_sudo, false
set :scm_passphrase, 'eshwar'
 
 
set :deploy_via, :remote_cache
 
default_run_options[:pty] = true
set :ssh_options, { :forward_agent => true }
 
set :domain, "sdb.schoolyardapp.net"
set :user, "eshwar"
set :deploy_to, "/home/eshwar/schoolapp"
set :adapter, 'mongrel' # or 'thin'
set :start_port, 7001
set :processes, 1
set :log_path, "#{shared_path}/log/production.log"
 
role :app, "sdb.schoolyardapp.net"
role :web, "sdb.schoolyardapp.net"
role :db, "sdb.schoolyardapp.net", :primary => true
 
 
namespace :deploy do
  
   desc "Copying the database to somewhere"
   task :before_update do
     run "mv #{current_path}/generic/db /home/eshwar"
     run "mv #{current_path}/generic/public/uploads /home/eshwar"
   end
  
  desc "Change the database configuration file"
  task :after_update do
     run "mv #{current_path}/generic/config/database.yml.production #{current_path}/generic/config/database.yml"
     run "mv /home/eshwar/db #{current_path}/generic"
     run "mv /home/eshwar/uploads #{current_path}/generic/public"
     run "cp #{current_path}/generic/lib/constantz.rb.sample #{current_path}/generic/lib/constantz.rb"
     run "cd #{current_path}/generic && rake db:migrate MERB_ENV=production"
     run "cd #{current_path}/generic && rake bootstrap:backup"
     run "scp #{current_path}/generic/db/schoolapp_production forge@schoolyardapp.com:/home/forge/backupdotnet/db_#{Time.now.strftime("%Y%m%d%H%M%S")}"
     run "tar zcf uploads_#{Date.today.strftime("%b%d")}.tar  #{current_path}/generic/public/uploads"
     run "scp -r /home/eshwar/uploads_#{Date.today.strftime("%b %d")}.tar forge@schoolyardapp.com:/home/forge/backupdotnet"
     run "cd #{current_path}/generic && rake basecamp:notify_new_build"
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
