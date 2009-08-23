Merb.start_environment(:environment => ENV['MERB_ENV'] || 'rake')

require 'fastercsv'

namespace :bootstrap do
  
  desc "Creating a records from the CSV File"
  task :csv do
      FasterCSV.foreach( Merb.root / 'lib' / 'svf_stdnt_data3.csv') do |row|
          record = Student.new({:last_name => row[0], :first_name => row[1], :address1 => row[4], 
                           :city => row[5], :state => row[6], :zip_code => row[7], :birth_date => '1/1/2000',
                                :school_id => 5 })
          record.save! 
                    @p1 = Protector.create({:last_name => row[0], :first_name => row[2], :school_id => 5 })
                    Ancestor.create({:student_id => record.id, :protector_id => @p1.id })
                    
                  if row[3].nil?
                  else
                    @p2 = Protector.create({:last_name => row[0], :first_name => row[3], :school_id => 5 })
                    Ancestor.create({:student_id => record.id, :protector_id => @p2.id })
                  end
          
          @current_school = School.find_by_id(5)
          @classroom = @current_school.classrooms.find_by_class_name(row[8])
          Study.create(:student_id => record.id, :classroom_id => @classroom.id)
      end
  end
  
end

