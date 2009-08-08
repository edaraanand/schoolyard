Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do
  
   require "ftools"
   
   desc "creating a back up file"
   task :backup do 
    
       backup_path = "/home/forge/sqlitebackupsdotcom/dbfiles"
       File.makedirs(backup_path)
  
       stored_file = backup_file(backup_path, File.basename('schoolapp_production'))
       File.copy "/home/forge/schoolapp/current/generic/db/schoolapp_production", stored_file

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
    
end

