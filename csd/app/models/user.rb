class User < ActiveRecord::Base
  
  def self.authenticate(email)
    self.find_by_email(email)
  end
  
  def enabled
    read_attribute(:content_access) 
  end
end
