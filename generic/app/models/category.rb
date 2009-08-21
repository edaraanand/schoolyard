class Category < ActiveRecord::Base
  
    belongs_to :report
    has_many :assignments, :dependent => :destroy 
    belongs_to :school
   
end                                       
