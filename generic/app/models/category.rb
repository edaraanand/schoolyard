class Category < ActiveRecord::Base
  
    belongs_to :report
    has_many :assignments
    belongs_to :school
   
end                                       
