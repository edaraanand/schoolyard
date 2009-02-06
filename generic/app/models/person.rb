class Person < ActiveRecord::Base
  
  attr_accessor :old_password
  
  # Relationships between the Models
  
  belongs_to :school
 
	has_many :access_peoples
	has_many :accesses, :through => :access_peoples, :source => :access
	
	has_many :class_peoples
  has_many :classrooms, :through => :class_peoples, :source => :classroom

  belongs_to :user
	has_many :announcements
	has_many :welcome_messages

	has_many :class_peoples
	has_many :teams, :through => :class_peoples, :source => :team
	
  has_many :alert_peoples
  has_many :alerts, :through => :alert_peoples
  
  has_many :home_works
                                          
  # Validations
  
  validates_presence_of :first_name, :last_name
	validates_presence_of :email, :if => :email
  validates_uniqueness_of :password_reset_key, :if => Proc.new{|m| !m.password_reset_key.nil?}, :scope => :school_id
  validates_uniqueness_of :email, :scope => :school_id, :if => :email 
  validates_format_of :email, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, :if => :email
  validates_length_of :phone, :is => 10, :message => 'must be 10 digits, excluding special characters such as spaces and dashes.', :if => Proc.new{|o| !o.phone.blank?}
  validates_length_of :password, :within => 4..40, :if => :password
 
  
    
  def self.authenticate(email, school_id, password)
      u = find_by_email_and_school_id(email, school_id) # need to get the salt
      return nil unless u
      u && u.authenticated?(password) ? u : nil
  end
  
   def password_validation_required
      new_record? || !@password.blank?
   end

	def accesses_without_all
	    accesses.delete_if{|x| x.name == "view_all"}
	end
	
 	def name
    # "#{first_name}"  "     "    "#{last_name}" 
    first_name + ' ' + last_name
  end
	
  def password_required?
     false
  end
  
  def self.make_key
      Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
  
  def reset_password
     pwreset_key_success = false
     until pwreset_key_success
        self.password_reset_key = self.class.make_key
        puts self.password_reset_key.inspect
        self.save!
        pwreset_key_success = self.errors.on(:password_reset_key).nil? ? true : false
     end
     send_forgot_password
  end
  
  def send_forgot_password
      deliver_email(:forgot_password, :subject => "Choose a Password to login" )
  end
 
  def deliver_email(action, params)
      from = "no-reply@insightmethods.com"
      PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.email), self )
  end
     
  def send_pass
     pwreset_key_success = false
     until pwreset_key_success
        self.password_reset_key = self.class.make_key
        puts self.password_reset_key.inspect
        self.save
        puts self.inspect
        pwreset_key_success = self.errors.on(:password_reset_key).nil? ? true : false
     end
     send_password
  end
  
  def send_password
      d_email(:password_staff, :subject => "Choose your Password to login in to schoolapps" )
  end
 
  def d_email(action, params)
      from = "no-reply@insightmethods.com"
      PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.email), self )
  end
  
end            


class Principle < Person
	
end




