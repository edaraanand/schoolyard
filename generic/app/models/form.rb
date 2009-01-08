class Form < ActiveRecord::Base
  
    validates_presence_of :title
    validates_presence_of :attachment, :message => 'Please Upload a Form'
  
    attr_accessor :attachment
             
  
    
 end
