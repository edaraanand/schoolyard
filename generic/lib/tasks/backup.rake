Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do
  
   require "ftools"
   
   desc "creating a back up file"
   task :backup do 
    
       backup_path = "/users/raja/backup"
       File.makedirs(backup_path)
  
       stored_file = backup_file(backup_path, File.basename('schoolapp_production'))
       File.copy "#{Merb.root}/db/schoolapp_production", stored_file

       if stored_file && File.exists?(stored_file)
          puts "Created backup: #{stored_file}"
          puts "Backup Complete"
       else
          puts "Unable to create backup"
       end
   end
   
   def backup_file(path, file)
      File.join(path, "db_#{Time.now.strftime("%Y%m%d%H%M%S")}_#{file}")
   end
  
   desc "downloading a datebase backup file"
   task :remote_db_download, :roles => :db, :only => { :primary => true } do  
     execute_on_servers(options) do |servers|
        self.sessions[servers.first].sftp.connect do |tsftp|
           tsftp.get_file "#{deploy_to}/#{current_dir}/db/schoolapp_production", "/users/raja" 
        end
     end
   end
 
    require 'net/ssh' 
   # require 'net/ssh/sftp/attrs' 
   # require 'net/ssh/sftp/constants' 
   # require 'net/ssh/sftp/session' 
   # require 'net/ssh/transport/buffer' 
   # require 'net/ssh/sftp/simple'

   desc "downloading a datebase backup file"
   task :remote_db_download do
       Net::SSH.new( "sdb.schoolyardapp.net", "eshwar", "murgi65" ) do |sftp| 
          status, body = sftp.get_file( "#{deploy_to}/#{current_dir}/db/schoolapp_production", "/users/raja" ) 
       end
   end
    
end

