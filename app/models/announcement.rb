class Announcement < ActiveRecord::Base

  require 'base_ext'

  attr_accessor :attachment
  attr_accessor :image
  
  belongs_to :person
  belongs_to :school
  has_many :logs, :class_name => "LoggerMachine"

  validates_presence_of :title, :if => :title, :scope => :school_id
  validates_presence_of :content, :if => :content, :scope => :school_id
  validates_presence_of :expiration
     
  def validate
     if self.expiration != nil
        self.errors.add(:expiration, "must be greater than today") if self.expiration <= Date.today 
     end
     if self.access_name == ""
         self.errors.add("please", "select the option")
     end
     if self.image
        if self.image != ""
          @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
          unless @content_types.include?(self.image[:content_type])
            self.errors.add("please", "upload a image")
          end 
        end
     end
  end
  
  def save_announcements(label, school_id)
     self.approved = false
     self.approve_announcement = true
     self.label = label
     self.school_id = school_id
     self.save
  end
  
  # sending email to Collaborative Methods on Feedback
  def feedback_email
    feedback_delivery(:feedback, :subject => "Feedback from " + self.school.school_name)
  end

  def feedback_delivery(action, params)
     PersonMailer.dispatch_and_deliver(action, params.merge(:from => Schoolapp.config(:auth_mailman), :to => "support@schoolyardapp.com"), self )
  end
 
  # sending the email reply to the person who has sent the feedback
  def reply_person
     feedback_reply_to_person(:reply_person, :subject => "Feedback Reply from " + self.school.school_name)
  end

  def feedback_reply_to_person(action, params)
     PersonMailer.dispatch_and_deliver(action, params.merge(:from => Schoolapp.config(:auth_mailman), :to => self.person.email), self )
  end

  ## Sending Emails for Announcement Alerts
  def alert_mail(id)
    @person =  Person.find_by_id_and_school_id(id, self.school.id) 
    email_alerts_delivery(:alert_details, @person, :subject => "Alert Details " + self.school.school_name)
  end
  
  def email_alerts_delivery(action, to, params)
    @person = to 
    PersonMailer.dispatch_and_deliver(action, params.merge(:from => Schoolapp.config(:auth_mailman), :to => @person.email), self )
  end
        
  # sending the mail for urgent Announcements
  def mail(action, params)
    @people = Person.find(:all, :conditions => ['school_id = ?', self.school.id])
    @people.each do |f|
      self.approved_by = f.id
      self.save
      unless f.email.blank?
        PersonMailer.dispatch_and_deliver(action, params.merge(:from => Schoolapp.config(:auth_mailman), :to => "#{f.email}" ), self )
      end
    end
  end
                                                                                                  
end