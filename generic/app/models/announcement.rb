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
  
  def urgent
     mail(:urgent_announcement, :subject => "Urgent Announcement for " + self.school.school_name)
  end
  
  
  def mail(action, params)
    from = "no-reply@example.com"
   # @current_school = self.school
   # @people = @current_school.people.find(:all)
   # array = @people.collect{|x| x.email}
   # to = array.compact!
   to =  ["shaan_lve007@yahoo.co.in", "dharmeshsanora@hotmail.com", "raja.gupta@kolkatacdac.in",
          "santu57@gmail.com", "ashu784@yahoo.com", "sunil_rishi2003@yahoo.com", 
          "ramit_bit@yahoo.co.in", "sujeethkv@yahoo.com", "ankbansal@gmail.com", 
          "subbiah_enmas@rediffmail.com", "vikas_the_gr8@yahoo.co.in", "jagadeesh.c27@gmail.com", 
          "prashil_gpta@yahoo.com", "rahulisdanger@rediffmail.com", "vj.madonna@gmail.com", 
          "santu57@gmail.com", "esh_as@yahoo.com", "toocool2bforu@hotmail.com",
          "foc_blacklotus@sify.com", "vinothan_87@yahoo.com", "rahulshri00@aol.com",
          "SIKANDER_CHHURI007@YAHOO.COM", "sumagrawal@gmail.com", "be_myfriend20in@yahoo.co.in",
          "lukes_shakes@yahoo.com", "asimjust4u@hotmail.co", "mayur.kirpekar@gmail.com",
          "ritwick.1981@gmail.com", "sindhuvenkat1947@gmail.com", "ashok78praveen@yahoo.co.in",
          "83.varsha@gmail.com", "urdude_05@yahoo.co.in", "pierce8686@gmail.com",
          "ronak007in@gmail.com", "anilkumargorantla@gmail.com", "alam_jmi@hotmail.com",
          "krezkewl@rediffmail.com", "aks_bakliwal@yahoo.co.in", "hafsarhsm@yahoo.co.in",
          "nitin_malik24@yahoo.com", "ratnesh_kumar@yahoo.co.in", "antony2810@yahoo.com",
          "anu2023@yahoo.com", "drsht_jain@yahoo.co.in", "archit_great@yahoo.com",
          "777simple@gmail.com", "test@gmail.com", "example@yahoo.com",
          "hello@methods.com", "testing@twitter.com"]
          
      PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => to.join(',') ), self )
  end
                                                                                                  
  
  
end
