class Alert < ActiveRecord::Base
  
  has_many :alert_people
  has_many :people, :through => :alert_peoples
  
end
