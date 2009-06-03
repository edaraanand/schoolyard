class Announcement < ActiveRecord::Base

  require 'base_ext'

  belongs_to :person
  belongs_to :school

  validates_presence_of :title, :if => :title, :scope => :school_id
  validates_presence_of :content, :if => :content, :scope => :school_id
  validates_presence_of :expiration, :if => :expiration, :scope => :school_id
  validates_presence_of :access_name, :message => "Please select the access from the drop down", :if => :access_name, :scope => :school_id

  attr_accessor :attachment
  attr_accessor :image
                                                             
  
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
    array = @people.collect{|x| x.email}
    to = array.compact!
    PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => to.join(',') ), self )
  end
                                                                                                  
  
  
end
