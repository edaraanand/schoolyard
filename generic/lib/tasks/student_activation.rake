Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do
  
  desc "Modifying student Activation Information"
  task :student_activate do
    @people = Person.find(:all)
    @people.each do |person|
      person.activate = true
      person.save!
    end
  end
  
end