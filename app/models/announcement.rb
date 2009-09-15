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
  #validates_presence_of :access_name, :message => "Please select the access from the drop down", :if => :access_name, :scope => :school_id
   
  def validate
     if self.expiration != nil
        self.errors.add(:expiration, "must be greater than today") if self.expiration <= Date.today 
     end
     if self.access_name == ""
         self.errors.add("please", "select the option")
     end
  end
  
    #      
    # def self.home_page(params)
    #    self.paginate(:all, :conditions => ["access_name = ? and label = ?", "Home Page", 'staff' ],
    #                       :order => "created_at DESC",
    #                       :per_page => 10,
    #                       :page => params[:page])
    # end 
    # 
    # def self.staff(params)
    #   self.paginate(:all, :conditions => ['label = ?', 'staff'],
    #                       :order => "created_at DESC",
    #                       :per_page => 10,
    #                       :page => params[:page])
    # end
    # 
    # def self.class_announcement(params)
    #   @current_school = School.find_by_id(params[:school_id])
    #   @classroom = @current_school.classrooms.find_by_id(params[:id])
    #   self.paginate(:all, :conditions => ["access_name = ? and label = ?", @classroom.class_name, 'staff' ],
    #                       :order => "created_at DESC",
    #                       :per_page => 10,
    #                       :page => params[:page])
    # end
    # 
    # def self.class_approved(params)
    #   @current_school = School.find_by_id(params[:school_id])
    #   @classroom = @current_school.classrooms.find_by_id(params[:id])
    #   self.paginate(:all, 
    #                 :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", @classroom.class_name, true, true],
    #                 :per_page => 10, :page => params[:page], :order => "created_at DESC")
    # end
    
  
    
  # sending email to Collaborative Methods on Feedback
    
  def feedback_email
    mail_deliver(:feedback, :subject => "Feedback from " + self.school.school_name)
  end

  def mail_deliver(action, params)
    from = "noreply@schoolyardapp.com"
    #to = "alok.saini@schoolyardapp.com"
    to = ["alok.saini@schoolyardapp.com", "eshwar@schoolyardapp.com", "steve.sandbank@collaborativemethods.com", "brian.bolz@insightmethods.com"]
    to.each do |f|
       PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => "#{f}"), self )
    end
  end
 
  # sending the email reply to the person who has sent the feedback
  
  def reply_person
     deliver(:reply_person, :subject => "Feedback Reply from " + self.school.school_name)
  end

  def deliver(action, params)
    from = "noreply@schoolyardapp.com"
    PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => self.person.email), self )
  end

  ## Sending mail for Announcement Alert

    def alert_mail(id)
      @current_school = self.school
      @person = @current_school.people.find_by_id(id)
      alert_deliver(:alert_details, @person, :subject => "Alert Details " + self.school.school_name)
    end

    def alert_deliver(action, to, params)
      @person = to 
      from = "noreply@schoolyardapp.com"
      PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => @person.email), self )
    end
    
    
  # sending the mail for urgent Announcements
  
  def mail(action, params)
    from = "noreply@schoolyardapp.com"
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
