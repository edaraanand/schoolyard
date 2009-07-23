class Student < Person
	    
     belongs_to :school
     has_many :guardians
     has_many :parents, :through => :guardians, :source => :parent
     
     has_many :studies
     has_many :classrooms, :through => :studies, :source => :classroom
     
     has_many :ancestors
     has_many :protectors, :through => :ancestors, :source => :protector
     
     has_many :grades
     has_many :assignments, :through => :grades, :source => :assignment
     
    # has_many :student_assignments
    # has_many :assignments, :through => :student_assignments, :source => :assignment
     
     #has_one :grade
    # has_many :grades
     
     has_one :rank
          
     validates_presence_of :birth_date
     validates_presence_of :address, :if => :address
     validates_presence_of :address1, :if  => :address1
     validates_presence_of :city, :if  => :city
     validates_presence_of :state, :if  => :state
     validates_presence_of :zip_code, :if  => :zip_code
     validates_format_of :zip_code, :if  => :zip_code, :with => %r{\d{5}(-\d{4})?}, :message => "should be 12345 or 12345-1234"
     
  
end
