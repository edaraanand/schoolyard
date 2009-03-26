class Parent < Person
	
     belongs_to :school
     
     has_many :guardians
     has_many :students, :through => :guardians, :source => :student
    
    validates_length_of :password, :within => 4..40, :if => :password
     
  def self.make_key
      Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
    
  def send_password_approve
     pwreset_key_success = false
     until pwreset_key_success
        self.password_reset_key = self.class.make_key
        puts self.password_reset_key.inspect
        puts "Naidu".inspect
        self.save
        pwreset_key_success = self.errors.on(:password_reset_key).nil? ? true : false
     end
     send_approve_password
  end
  
  def send_approve_password
      deliver_email(:new_password, :subject => "You application is approved")
  end
 
  def deliver_email(action, params)
      from = "no-reply@insightmethods.com"
      PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.email), self )
  end
 
     
end
