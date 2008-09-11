class User < ActiveRecord::Base
  
   include MerbAuth::Adapter::ActiveRecord
    attr_accessor :old_password
     has_many :alerts

  #validates_presence_of :first_name, :last_name, :email
  #validates_uniqueness_of :email

  #validates_presence_of :password
  #validates_presence_of :password_confirmation
  #validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => :true

  # def self.authenticate(email)
      # self.find_by_email(email)
  # end

    #def password_check?(pass)
       # self.password == self.class.sha1(pass)
    #end
  
   #def enabled?
    #   current_user.content_access != false
       #read_attribute(:content_access) 
   #end

         
end
