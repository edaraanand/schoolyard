Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')

require 'fastercsv'

namespace :bootstrap do
  
  desc "Creating a records from the CSV File"
  task :sjs_csv do
      
      FasterCSV.foreach( Merb.root / 'lib' / 'sjs_data.csv') do |row|
      
         student = Student.create({:last_name => row[0], :first_name => row[1], :birth_date => row[10], :school_id => 3 })    
                   
         parent = Protector.create({:last_name => row[2], :first_name => row[3], :school_id => 3 })
         Ancestor.create({:student_id => student.id, :protector_id => parent.id })
         
         if row[4].nil?
         else
           parent2 = Protector.create({:last_name => row[4], :first_name => row[5], :school_id => 3 })
           Ancestor.create({:student_id => student.id, :protector_id => parent2.id })
         end
         
         @current_school = School.find_by_id(3)
         @classroom = @current_school.classrooms.find_by_class_name(row[11])
         Study.create(:student_id => student.id, :classroom_id => @classroom.id)
      end
  end
  
end