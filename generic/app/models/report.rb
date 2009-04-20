class Report < ActiveRecord::Base
  
    has_many :categories
    belongs_to :person
    
    validates_presence_of :subject_name
    
end
