Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')
namespace :bootstrap do
  
  desc "Modifying student Address Information"
  task :student do
    @students = Student.find(:all)
    @students.each do |student|
      str = student.address.split(',')
      student.address1 = str[0]
      student.city = str[1]
      student.state = str[2]
      student.zip_code = str[3]
      student.save!
    end
  end
  
end