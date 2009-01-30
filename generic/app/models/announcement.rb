class Announcement < ActiveRecord::Base
	
 
     belongs_to :person
     belongs_to :school
     
     validates_presence_of :title, :content, :expiration
     validates_presence_of :access_name, :message => "Please select the access from the drop down", :if => :access_name
 
     attr_accessor :attachment
   
end
