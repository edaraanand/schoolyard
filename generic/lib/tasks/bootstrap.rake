Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do
  desc "creating Access for the people"
  task :app do
    accesses = {
      :announcements => "Add/Edit Announcements",
      :approve_announcement => "Approve Announcements",
      :spotlight => "Add/Edit Spotlight Information",
      :homework => "Add/Edit Homework",
      :grades => "Add/Edit Grades",
      :calendar => "Add/Edit Calendar",
      :teams => "Add/Edit Teams",
      :from_principal => "Add/Edit From the Principal message",
      :manage_directory => "Manage Directories",
      :rights_others => "Add/Edit Access Rights for others",
      :parent_registration => "Approve Parent Registration",
      :view_all => "View all Content"
    }
      
      accesses.each_pair do |key, value|
         Access.create({:name => "#{key}", :full_name => "#{value}"})
      end
 
  end
 
end