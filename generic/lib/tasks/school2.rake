Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace:school2 do
  
  desc "creating a school information"
   task :school do
     @school = School.create({
         :school_name => "St James School",
         :phone => "11111111",
         :email => "sjs@schoolyardapp.com",
         :domain => "http://sjs.schoolyardapp.com",
         :folder => "schoolyardappcom",
         :subdomain => 'sjs'
        })
   end
   
   task :person => :school do
       @staff = Staff.create({
           :title => "Mrs.",
           :first_name => "Lori",
           :last_name => "James",
           :email => "sjs@schoolyardapp.com",
           :type => 'Staff',
           :password => 'sjs',
           :password_confirmation => 'sjs',
           :school_id => @school.id
      })
       
       @view = Access.find_by_name('view_all')
       AccessPeople.create({:person_id => @staff.id, :access_id => @view.id })
       AccessPeople.create({:person_id => @staff.id, :all => true })
  end

 
end
