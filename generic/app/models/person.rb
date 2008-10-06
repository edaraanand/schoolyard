class Person < ActiveRecord::Base
	has_many :access_peoples
	has_many :accesses, :through => :access_peoples, :source => :access
	
	has_many :class_peoples
        has_many :classrooms, :through => :class_peoples, :source => :classroom

        belongs_to :user
	has_many :announcements
	has_many :welcome_messages
	
	def accesses_without_all
	    accesses.delete_if{|x| x.name == "view_all"}
	end
end            
  
class Student < Person
	
     has_many :guardians
     has_many :parents, :through => :guardians, :source => :parent
     
     has_many :studies
     has_many :classrooms, :through => :studies, :source => :classroom
     
end

class Staff < Person
  
end

class Parent < Person
     has_many :guardians
     has_many :students, :through => :guardians, :source => :student
end

class Principle < Person
end

  
