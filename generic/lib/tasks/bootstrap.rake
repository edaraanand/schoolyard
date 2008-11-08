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
 
  desc "Creating a default person"
  task :app do
       Staff.create({
      :first_name => "Admin",
      :last_name => "administration",
      :email => "school@insight",
      :type => 'Staff'
      })
  end
  
  desc "creating alerts for both parents and staff"
  task :app do
     alerts = {
       :announcements => "Announcement is Posted",
       :home_work => "Home Work Assignment",
       :from_principal => "From the Principal",
       :first_grade => "1st Grade",
       :second_grade => "2nd Grade",
       :third_grade => "3rd Grade",
       :fourth_grade => "4th Grade",
       :fifth_grade => "5th Grade",
       :sixth_grade => "6th Grade",
       :seventh_grade => "7th Grade",
       :eighth_grade => "8th Grade",
       :sports => "Sports"
     }
     
     alerts.each_pair do |key, value|
        Alert.create({:name => "#{key}", :full_name => "#{value}"})
     end
     
   end

   
end