class WelcomeMessage < ActiveRecord::Base
  
    belongs_to :person
    belongs_to :school
    
  
    validates_presence_of :content
     
      
end
