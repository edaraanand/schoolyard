class Form < ActiveRecord::Base
  
   belongs_to :school
  
   attr_accessor :attachment
   
   validates_presence_of :title
   validates_presence_of :attachment, :message => 'Please Upload a Form'
  
    
             
  
    
 end
