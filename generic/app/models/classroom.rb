class Classroom < ActiveRecord::Base
  
	has_many :class_peoples
        has_many :people, :through => :class_peoples, :source => :person
	
	has_many :studies
	has_many :students, :through => :studies, :source => :student
	
	has_many :class_peoples
	has_many :teams, :through => :class_peoples, :source => :team
	
	validates_presence_of :class_name
	#validates_presence_of :class_name, :on => :update
	 #, :if => :class_name
end