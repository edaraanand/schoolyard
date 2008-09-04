class User < ActiveRecord::Base
  

  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => :true

   def self.authenticate(email)
       self.find_by_email(email)
   end
  
   def enabled
       read_attribute(:content_access) 
   end

         
end
