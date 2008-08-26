class Classroom < ActiveRecord::Base
  
    has_many :classtypes
    
    has_many :class_peoples
    has_many :class_students
   
    has_many :people, :through => :class_students
   
end