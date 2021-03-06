class Report < ActiveRecord::Base
  
    has_many :categories, :dependent => :destroy 
    belongs_to :person
    belongs_to :school
    belongs_to :classroom
    
    validates_presence_of :subject_name
    
end
