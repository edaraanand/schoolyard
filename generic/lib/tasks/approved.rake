Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do
  
  desc "backing up the database and uploaded files"
  task :approved  do
     @staff = Staff.find(:all)
     @staff.each do |staff|
       staff.approved = 1
       staff.save
     end
  end
  
end