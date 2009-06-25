class Attachment < ActiveRecord::Base


  def url
    "/public/uploads/#{self.id}/#{self.filename}"
  end

  belongs_to :school

end
