class Classroom < ActiveRecord::Base
  
	has_many :class_peoples
        has_many :people, :through => :class_peoples, :source => :person
   
end