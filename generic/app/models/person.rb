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
     belongs_to :parent
end

class Staff < Person
  
end

class Parent < Person
     has_many :students
end

class Principle < Person
end

  
