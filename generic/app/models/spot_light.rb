class SpotLight < ActiveRecord::Base
  
  attr_accessor :image
  
  belongs_to :school
  
end
