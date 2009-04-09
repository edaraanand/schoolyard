Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :contact do
    
    desc "creating a school profile access"
    task :school do
        access = { :basic_settings => "Add/Edit School Profile"}
        access.each_pair do |key, value|
            Access.create({:name => "#{key}", :full_name => "#{value}"})
        end
        @staff = Person.find(:first, :conditions => ['email = ? and type = ?', "school@insightmethods.com", "Staff"])
        @view = Access.find_by_name('basic_settings')
         # AccessPeople.create({:person_id => @staff.id, :access_id => @view.id })
    end
end
