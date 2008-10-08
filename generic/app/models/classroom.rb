class Classroom < ActiveRecord::Base
  
	has_many :class_peoples
        has_many :people, :through => :class_peoples, :source => :person
	
	has_many :studies
	has_many :students, :through => :studies, :source => :student
end