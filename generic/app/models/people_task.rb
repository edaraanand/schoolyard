class PeopleTask < ActiveRecord::Base
 
  belongs_to :person
  belongs_to :task
  belongs_to :school
    
end
