class ExternalLink < ActiveRecord::Base
	
  
  belongs_to :school
  
  validates_presence_of :title, :url 
	
	
end
