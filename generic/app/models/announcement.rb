class Announcement < ActiveRecord::Base
	
 
     belongs_to :person
     belongs_to :school
     
     validates_presence_of :title, :content, :expiration, :scope => :school_id
     validates_presence_of :access_name, :message => "Please select the access from the drop down", :if => :access_name, :scope => :school_id
 
     attr_accessor :attachment
     attr_accessor :image
     
   

end
