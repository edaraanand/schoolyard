class AlertPeople < ActiveRecord::Base
  belongs_to :person
  belongs_to :alert
  
  belongs_to :classroom
end
