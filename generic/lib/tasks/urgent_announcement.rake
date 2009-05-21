Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :announcement do
    
  desc "creating a urgent Announcement access"
    task :urgent do
        access = { :urgent_announcement => "Add/Edit Urgent Announcements"}
        access.each_pair do |key, value|
            Access.create({:name => "#{key}", :full_name => "#{value}"})
        end
    end
end
