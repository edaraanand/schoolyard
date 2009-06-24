class Assignment < ActiveRecord::Base
  
    belongs_to :category
    belongs_to :school
    belongs_to :student
    
    has_many :grades
    
    has_many :ranks
    
    # validates_presence_of :name, :date, :max_point
    #validates_numericality_of :max_point
    
end               
