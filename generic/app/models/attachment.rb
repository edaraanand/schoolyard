class Attachment < ActiveRecord::Base


  def url
    "/public/uploads/#{self.id}/#{self.filename}"
  end


end
