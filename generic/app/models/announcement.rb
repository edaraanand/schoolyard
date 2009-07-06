class Announcement < ActiveRecord::Base

  require 'base_ext'

  belongs_to :person
  belongs_to :school

  validates_presence_of :title, :if => :title, :scope => :school_id
  validates_presence_of :content, :if => :content, :scope => :school_id
  validates_presence_of :expiration
  validates_presence_of :access_name, :message => "Please select the access from the drop down", :if => :access_name, :scope => :school_id
 # validates_format_of :content, :with => %r{(/[^a-zA-Z0-9-]/)}i #:if => Proc.new{|o| o.include?.blank?} #:with => /[^a-zA-Z0-9-]/
   # :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, 
   
  attr_accessor :attachment
  attr_accessor :image
  
  def validate
     if self.expiration != nil
        self.errors.add(:expiration, "must be greater than today") if self.expiration <= Date.today 
     end
  end
                                                                          
  # sending email to Collaborative Methods on Feedback
    
  def feedback_email
    mail_deliver(:feedback, :subject => "Feedback from " + self.school.school_name)
  end

  def mail_deliver(action, params)
    from = "no-reply@insightmethods.com"
    to = "alok.saini@schoolyardapp.com"
    PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => to), self )
  end
 
  # sending the email reply to the person who has sent the feedback
  
  def reply_person
     deliver(:reply_person, :subject => "Feedback Reply from " + self.school.school_name)
  end

  def deliver(action, params)
    from = "no-reply@insightmethods.com"
    PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.person.email), self )
  end

  # sending the mail for urgent Announcements
  
  def mail(action, params)
    from = "no-reply@schoolyardapp.com"
    @current_school = self.school
    @people = @current_school.people.find(:all)
    @people.each do |f|
      self.approved_by = f.id
      self.save
      unless f.email.blank?
        PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => "#{f.email}" ), self )
      end
    end
  end
                                                                                                  
  
  
end
