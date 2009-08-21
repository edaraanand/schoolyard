class Person < ActiveRecord::Base

  attr_accessor :old_password
  attr_accessor :image
   
  # Relationships between the Models

  belongs_to :school

  has_many :access_peoples
  has_many :accesses, :through => :access_peoples, :source => :access

  has_many :class_peoples
  has_many :classrooms, :through => :class_peoples, :source => :classroom
  
  has_many :people_tasks
  has_many :tasks, :through => :people_tasks, :source => :task

  belongs_to :user
  has_many :announcements
  has_many :welcome_messages

  has_many :class_peoples
  has_many :teams, :through => :class_peoples, :source => :team

  has_many :alert_peoples
  has_many :alerts, :through => :alert_peoples

  has_many :home_works

  has_many :reports
  



  # Validations
  
  validates_presence_of :first_name, :last_name
  validates_presence_of :email, :if => :email
  validates_uniqueness_of :email, :if => :email, :scope => [:school_id, :type]
  validates_format_of :email, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, :if => :email
  validates_uniqueness_of :password_reset_key, :if => Proc.new{|m| !m.password_reset_key.nil?}, :scope => [:school_id, :type]
  validates_length_of :password, :within => 8..40, :if => :password
  validates_length_of :phone, :is => 10, :message => 'must be 10 digits, excluding special characters such as spaces and dashes.', :if => Proc.new{|o| !o.phone.blank?}
  validates_length_of :voice_alert, :is => 10, :message => 'must be 10 digits', :if => Proc.new{|o| !o.voice_alert.blank?}    
  validates_length_of :sms_alert, :is => 10, :message => 'must be 10 digits', :if => Proc.new{|o| !o.sms_alert.blank?}


  def self.authenticate(email, school_id, password)
    u = find_by_email_and_school_id(email, school_id) # need to get the salt
    return nil unless u
    if u.activate = true
       u && u.authenticated?(password) ? u : nil
    end
  end

  def password_validation_required
    new_record? || !@password.blank?
  end

  def accesses_without_all
    accesses.delete_if{|x| x.name == "view_all"}
  end

  def name
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
      self.save!
      pwreset_key_success = self.errors.on(:password_reset_key).nil? ? true : false
    end
    send_forgot_password
  end

  def send_forgot_password
    deliver_email(:forgot_password, :subject => "Password reset instructions for " + self.school.school_name)
  end

  def deliver_email(action, params)
    from = "noreply@schoolyardapp.com"
    PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.email), self )
  end


 ## sending the Mail for Staff after creating and after enable process

    def send_p
      pwreset_key_success = false
      until pwreset_key_success
        self.password_reset_key = self.class.make_key
        self.save
        pwreset_key_success = self.errors.on(:password_reset_key).nil? ? true : false
      end
      send_pwd
    end

    def send_pwd
      d_email(:new_staff_password, :subject => "Choose your Password to login to " + self.school.school_name )
    end

    def d_email(action, params)
      from = "noreply@schoolyardapp.com"
      PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.email), self )
    end


  ## Notifying the Staff about their Account Details
  
    def changed_details
      mail_deliver(:notify_staff_details, :subject => "Your details have changed for " + self.school.school_name)
    end

    def mail_deliver(action, params)
      from = "noreply@schoolyardapp.com"
      PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.email), self )
    end


  # Changing the password reset key after the user clicks
  
    def resetting
       pwreset_key_success = false
       until pwreset_key_success
         self.password_reset_key = self.class.make_key
         self.save
         pwreset_key_success = self.errors.on(:password_reset_key).nil? ? true : false
       end
    end
  

end



