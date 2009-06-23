class Student < Person
	    
     belongs_to :school
     has_many :guardians
     has_many :parents, :through => :guardians, :source => :parent
     
     has_many :studies
     has_many :classrooms, :through => :studies, :source => :classroom
     
     has_many :ancestors
     has_many :protectors, :through => :ancestors, :source => :protector
     
     has_one :grade
     
      
     validates_presence_of :birth_date
     validates_presence_of :address
  
end
