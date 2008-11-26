class Attachment < ActiveRecord::Base
  
  #belongs_to :form
  
  
  
  def url
    "/uploads/#{self.id}/#{self.filename}"
  end
  
  
    

end
