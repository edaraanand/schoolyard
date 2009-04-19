class SpotLight < ActiveRecord::Base
  
     attr_accessor :image
     
     belongs_to :school
     
     validates_presence_of :content
     
     
end
