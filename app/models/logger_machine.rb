class LoggerMachine < ActiveRecord::Base

  belongs_to :school
  belongs_to :person
  belongs_to :announcement
  
end
