class Rank < ActiveRecord::Base
  
  belongs_to :student
  belongs_to :school
  belongs_to :assignment
  
 # validates_presence_of :from, :to, :name
#  validates_uniqueness_of :from, :to, :scope => :school_id
  
 
end
