class Form < ActiveRecord::Base
  
   attr_accessor :attachment
   
   belongs_to :school
  
   validates_presence_of :title
   
  
     
end
