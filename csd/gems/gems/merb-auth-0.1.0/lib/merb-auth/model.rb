require 'digest/sha1'

module MerbAuth
  def self.use_adapter(adapter)
    require File.join(File.dirname(__FILE__), "adapter", adapter.to_s)
  end
  
  module BaseModel
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend,  ClassMethods)
      
      base.class_eval do
        attr_accessor :password, :password_confirmation
      end
    end
    
    module InstanceMethods
      def authenticated?(password)
         crypted_password == encrypt(password)
      end      

      # before filter 
      def encrypt_password
        return if password.blank?
        self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--") if new_record?
        self.crypted_password = encrypt(password)
      end
      
      # Encrypts the password with the user salt
      def encrypt(password)
        self.class.encrypt(password, salt)
      end
      
      def remember_token?
        remember_token_expires_at && Date.today < remember_token_expires_at
      end

      def remember_me_until(time)
        self.remember_token_expires_at = time
        self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
        save
      end

      def remember_me_for(days)
        remember_me_until (Date.today + days)
      end

      # These create and unset the fields required for remembering users between browser closes
      # Default of 2 weeks 
      def remember_me
        remember_me_for(14)
      end

      def forget_me
        self.remember_token_expires_at = nil
        self.remember_token            = nil
        self.save
      end
      
      protected
        def password_required?
          crypted_password.blank? || !password.blank?
        end      
    end
    
    module ClassMethods
      # Encrypts some data with the salt.
      def encrypt(password, salt)
        Digest::SHA1.hexdigest("--#{salt}--#{password}--")
      end
      
      # Authenticates a user by their username and unencrypted password.  Returns the user or nil.
      def authenticate(username, password)
          u = find_by_username(username) # need to get the salt
          u && u.authenticated?(password) ? u : nil
      end
    end
  end
end
