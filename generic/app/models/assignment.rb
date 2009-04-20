class Assignment < ActiveRecord::Base
  
    belongs_to :category
    
    #validates_presence_of :name, :date, :max_point
    
end
