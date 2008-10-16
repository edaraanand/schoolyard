class WelcomeMessage < ActiveRecord::Base
      belongs_to :person
      
      validates_presence_of :content
      validates_presence_of :access_name, :message => "Please select the access from the drop down"
      
end
