class Person < ActiveRecord::Base
  
  attr_accessor :old_password
  
  validates_presence_of :first_name, :last_name
	validates_presence_of :address, :if => :address
	validates_presence_of :email, :if => :email
	#validates_uniqueness_of :email, :if => :email
	#validates_presence_of :birth_date, :if => :birth_date
  validates_uniqueness_of :password_reset_key, :if => Proc.new{|m| !m.password_reset_key.nil?}
  
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
  
	def accesses_without_all
	    accesses.delete_if{|x| x.name == "view_all"}
	end
	
 	def name
     "#{first_name}"  "     "    "#{last_name}" 
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
        puts "Naidu".inspect
        self.save
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
  
end            
  
class Student < Person
	
     has_many :guardians
     has_many :parents, :through => :guardians, :source => :parent
     
     has_many :studies
     has_many :classrooms, :through => :studies, :source => :classroom
        
     
end

class Staff < Person
	
                            
end

class Parent < Person
	
     has_many :guardians
     has_many :students, :through => :guardians, :source => :student
     
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
      deliver_email(:new_password, :subject => "Choose your Password to login in to schoolapps" )
  end
 
  def deliver_email(action, params)
      from = "no-reply@insightmethods.com"
      PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.email), self )
  end
 
     
end

class Principle < Person
	
end

  
