class Person < ActiveRecord::Base
	has_many :access_peoples
	has_many :accesses, :through => :access_peoples, :source => :access
	
	has_many :class_peoples
  has_many :classrooms, :through => :class_peoples, :source => :classroom

  belongs_to :user
	has_many :announcements
	has_many :welcome_messages
	
	has_many :class_peoples
	has_many :teams, :through => :class_peoples, :source => :team
	
  has_many :alert_peoples
  has_many :alerts, :through => :alert_peoples
  
	def accesses_without_all
	    accesses.delete_if{|x| x.name == "view_all"}
	end
	
 	def name
     "#{first_name}"  "     "    "#{last_name}" 
  end
	
  attr_accessor :old_password
  
	validates_presence_of :first_name, :last_name
	validates_presence_of :address, :if => :address
	validates_presence_of :email, :if => :email
	validates_uniqueness_of :email, :if => :email
	
end            
  
class Student < Person
	
     has_many :guardians
     has_many :parents, :through => :guardians, :source => :parent
     
     has_many :studies
     has_many :classrooms, :through => :studies, :source => :classroom
     
     #def parent_attributes=(parent_attributes)
	# parent_attributes.each do |attributes|
	 #    parents.build(attributes)
         #end
     #end
     
     # def f_for(array_or_object, *args, &block)
        #  raise ArgumentError, "Missing block" unless block_given?
	#  if Enumerable === array_or_object
	#     f_for_enumerable(array_or_object, *args, &block)
        #  else
        #     f_for_object(array_or_object, *args, &block)
        #  end
     # end
      
end

class Staff < Person
	

end

class Parent < Person
	
     has_many :guardians
     has_many :students, :through => :guardians, :source => :student
     
    # validates_presence_of :first_name, :on => :update

end

class Principle < Person
	
end

  
