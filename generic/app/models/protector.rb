class Protector < ActiveRecord::Base
  
   has_many :ancestors
   has_many :students, :through => :ancestors, :source => :student
   
   validates_presence_of :first_name, :last_name, :email
   
   	def name
       "#{first_name}"  "     "    "#{last_name}" 
    end
  
end
