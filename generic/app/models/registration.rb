class Registration < ActiveRecord::Base
  
  
   validates_presence_of :first_name, :last_name
   validates_presence_of :current_class
   validates_presence_of :birth_date
  
   	def name
     "#{first_name}"  "     "    "#{last_name}" 
    end
    
end              
