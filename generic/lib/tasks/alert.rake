Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do

    desc "creating alerts for both parents and staff"
    task :alert do
        alerts = OrderedHash.new
        alerts = { :principal_message => "New From the Principal Message is added", 
                   :approve_announcement => "My Announcements are approved",
                   :grades => "New Grade/Report is added",
                   :announcement => "New Announcement",
                   :home_work_message => "New Homework Assignment",
                   :principal_message_staff => "New From the Principal Message is added"
                 }
         alerts.each_pair do |key, value|
             Alert.create({:name => "#{key}", :full_name => "#{value}"})
         end
         @alerts = Alert.find(:all)
         @alerts.each do |a|
             if (a.name == "approve_announcement") || (a.name == "principal_message_staff") 
                a.type = "Staff"
             else
               a.type = "Parent"
             end
             a.save
         end
     end

end
