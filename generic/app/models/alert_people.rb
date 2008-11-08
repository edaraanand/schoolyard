class AlertPeople < ActiveRecord::Base
  belongs_to :person
  belongs_to :alert
end
