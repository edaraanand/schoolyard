Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do
  
  desc "creating a school information"
   task :school do
     @school = School.create({
         :school_name => "St Benecia School",
         :phone => "9998805789",
         :email => "sdb@schoolyardapp.net",
         :domain => "http://sdb.schoolyardapp.net",
         :folder => "schoolyardappcom",
         :subdomain => 'sdb'
        })
   end
   
  desc "creating Access for the people"
  task :access => :school do
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
      :view_all => "View all Content",
      :welcome_messages => "Add/Edit Welcome Message",
      :external_links => "Add/Edit External Links",
      :forms => "Add/Edit Forms",
      :classes => "Classes"
     }
      
      accesses.each_pair do |key, value|
         Access.create({:name => "#{key}", :full_name => "#{value}"})
      end
     
  end
  
  desc "Creating a default person"
    task :person => :access do
       @staff = Staff.create({
           :title => "Mr.",
           :first_name => "John",
           :last_name => "Meyer",
           :email => "school@insight",
           :type => 'Staff',
           :password => 'admin',
           :password_confirmation => 'admin',
           :school_id => @school.id
      })
       
       @view = Access.find_by_name('view_all')
       AccessPeople.create({:person_id => @staff.id, :access_id => @view.id })
       AccessPeople.create({:person_id => @staff.id, :all => true })
  end
  
 
 
  
  desc "creating alerts for both parents and staff"
  task :alerts => :person do
     alerts = ["1st Grade", "2nd Grade","3rd Grade", "4th Grade","5th Grade", "6th Grade", "7th Grade",
                "8th Grade", "Announcement is Posted", "Home Work Assignment", "From the Principal",
                 "Sports"]
   
     alerts.each do |x|
        Alert.create({:name => "#{x}", :full_name => "#{x}"})
     end
     
   end
 
   
   
end