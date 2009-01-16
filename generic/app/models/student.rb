class Student < Person
	
     has_many :guardians
     has_many :parents, :through => :guardians, :source => :parent
     
     has_many :studies
     has_many :classrooms, :through => :studies, :source => :classroom
     
     has_many :ancestors
     has_many :protectors, :through => :ancestors, :source => :protector
      
     validates_presence_of :birth_date
     validates_presence_of :address
end