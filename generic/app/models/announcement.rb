class Announcement < ActiveRecord::Base
     #include Paperclip
    
     belongs_to :person
     
    # has_attached_file :file,
                    #   :storage => :filesystem,
                #       :styles => { :medium => "300x300>", :thumb => "100x100>" }
     
    
end
