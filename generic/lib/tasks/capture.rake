Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')

namespace :bootstrap do
  
  desc "creating a urgent Announcement access"
  task :capture do
      access = {:time_capture => "Add/Edit Time Capture Forms"}
      access.each_pair do |key, value|
          Access.create({:name => "#{key}", :full_name => "#{value}"})
      end
  end
    
end