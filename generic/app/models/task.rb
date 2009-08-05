class Task < ActiveRecord::Base
  
  belongs_to :school
  belongs_to :capture
  
  has_many :people_tasks, :dependent => :destroy
  has_many :people, :through => :people_tasks, :source => :person
  
end
