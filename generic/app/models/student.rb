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
     validates_presence_of :address
  
end
