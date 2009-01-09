class Attachment < ActiveRecord::Base
  
  #has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => "100x100>" }
 # belongs_to :form
 
   
  def url
    "/public/uploads/#{self.id}/#{self.filename}"
  end

 
  
end                         
