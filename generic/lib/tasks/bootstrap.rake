Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do
  
  desc "creating a school information"
   task :school do
     @school = School.create({
         :school_name => "St Domnic School",
         :phone => "7077451266",
         :address1 => "935 East 5th Street",
         :city => "Benecia",
         :state => "CA",
         :zip_code => "94510",
         :fax => "7077451841",
         :email => "sdb@schoolyardapp.com",
         :domain => "http://sdb.schoolyardapp.com",
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
      :classes => "Classes",
      :feedback => "Manage Feedback",
      :urgent_announcement => "Add/Edit Urgent Announcements",
      :basic_settings => "Add/Edit School Profile"
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
           :email => "school@insightmethods.com",
           :type => 'Staff',
           :password => 'administration',
           :password_confirmation => 'administration',
           :school_id => @school.id,
           :admin => 'true'
      })
       
       @view = Access.find_by_name('view_all')
       AccessPeople.create({:person_id => @staff.id, :access_id => @view.id })
       AccessPeople.create({:person_id => @staff.id, :all => true })
    end
  
 
  
   
end