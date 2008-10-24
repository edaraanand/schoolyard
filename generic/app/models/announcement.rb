class Announcement < ActiveRecord::Base
	
     #include Paperclip
    
     belongs_to :person
     validates_presence_of :title, :content
     validates_presence_of :access_name, :message => "Please select the access from the drop down", :if => :access_name
     
    # has_attached_file :file,
                    #   :storage => :filesystem,
                     #  :styles => { :medium => "300x300>", :thumb => "100x100>" }
     
    
end
