Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace:admin do
  
  desc "creating a school information"
   task :school do
     @school = School.create({
         :school_name => "Insight Methods",
         :phone => "1234567890",
         :email => "admin@schoolyardapp.com",
         :domain => "http://admin.schoolyardapp.com",
         :folder => "schoolyardappcom",
         :subdomain => 'admin'
        })
   end
   
   task :person => :school do
       @staff = Staff.create({
           :title => "Mr.",
           :first_name => "Brian",
           :last_name => "Bolz",
           :email => "brian.bolz@insightmethods.com",
           :type => 'Staff',
           :password => 'brianbolz',
           :password_confirmation => 'brianbolz',
           :school_id => @school.id,
           :admin => 'true'
      })
       
       @view = Access.find_by_name('view_all')
       AccessPeople.create({:person_id => @staff.id, :access_id => @view.id })
       AccessPeople.create({:person_id => @staff.id, :all => true })
  end

 
end
