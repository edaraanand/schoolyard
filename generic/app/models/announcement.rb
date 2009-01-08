class Announcement < ActiveRecord::Base
	
     #include Paperclip
    
     belongs_to :person
     validates_presence_of :title, :content
     validates_presence_of :access_name, :message => "Please select the access from the drop down", :if => :access_name
      
end
