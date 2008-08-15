class Classroom < ActiveRecord::Base
    has_many :classtypes
    
    has_many :class_students
   # has_many :class_teachers
    has_many :people, :through => :class_students
    #has_many :teachers, :through => :class_teachers, :source => 'first_name'
end