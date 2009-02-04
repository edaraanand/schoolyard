Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace:school do
  
  desc "creating a school information"
   task :school do
     @school = School.create({
         :school_name => "St James School",
         :phone => "1234567890",
         :email => "sjs@schoolyardapp.net",
         :domain => "http://sjs.schoolyardapp.net",
         :folder => "schoolyardappcom",
         :subdomain => 'sjs'
        })
   end
   
   task :person => :school do
       @staff = Staff.create({
           :title => "Mrs.",
           :first_name => "Lori",
           :last_name => "James",
           :email => "sjs@schoolyardapp.net",
           :type => 'Staff',
           :password => 'lori',
           :password_confirmation => 'lori',
           :school_id => @school.id
      })
       
       @view = Access.find_by_name('view_all')
       AccessPeople.create({:person_id => @staff.id, :access_id => @view.id })
       AccessPeople.create({:person_id => @staff.id, :all => true })
  end

 
end
