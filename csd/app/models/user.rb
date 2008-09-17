class User < ActiveRecord::Base
  
   include MerbAuth::Adapter::ActiveRecord
     attr_accessor :old_password
     has_many :alerts
     validates_uniqueness_of :password_reset_key, :if => Proc.new{|m| !m.password_reset_key.nil?} 

    def reset_pass 
       pwreset_key_success = false
        until pwreset_key_success
          self.password_reset_key = self.class.make_key
          self.save
          puts password_reset_key.inspect
          pwreset_key_success = self.errors.on(:password_reset_key).nil? ? true : false
        end
       send_forgot_password
    end
    
    def self.make_key
        Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def has_forgotten_password?
        !self.password_reset_key.nil?
    end

    def send_forgot_password
        puts "Eshwar"
      deliver_email(:forgot_password, :subject => (MerbAuth[:password_request_subject] || "Request to change your password"))
    end 

    def deliver_email(action, params)
        from = MerbAuth[:from_email]
         puts "Gouthama"
        MerbAuth::UserMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.email), MerbAuth[:single_resource] => self)
    end
   
    

end
