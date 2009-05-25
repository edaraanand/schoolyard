   require "twiliorest.rb"
  
   # your Twilio authentication credentials  
   ACCOUNT_SID = 'ACa1b7ee5abe50974956bda599447b1f04'  
   ACCOUNT_TOKEN = '208232dfbc82563e6c2f9cdc54cafbe5' 
   
   # Twilio REST API version
   API_VERSION = '2008-08-01'
   
   # # base URL of this application  
   # BASE_URL = "http://sdb.#{Schoolapp.config(:app_domain)}"
   BASE_URL = "http://sdb.schoolyardapp.net"
   
   #school@insightmethods.com:administration@
   
   #https://username:password@api.twilio.com/2008-08-01 ..
    
   # Outgoing Caller ID you have previously validated with Twilio  
   CALLER_ID = '(415) 287-0729'  
   CALLED = '530 554 1373'
   
  # CALLED = '571 332 0672'
  # CALLED = ' 530-756-8158' Brian
  # CALLED = '+14152870729' AJ

class Notifications < Application
   layout 'default'
   before :access_rights, :exclude => [:reminder, :directions] 
   before :find_school
   
   
  def index
     @announcements = @current_school.announcements.paginate(:all,
                                                             :conditions => ['label=?', "urgent"],
                                                             :order => "created_at DESC",
                                                             :per_page => 10,
                                                             :page => params[:page] )
     render
  end
  
  def new
    @announcement = Announcement.new
    render
  end                                
  
  def create
     @announcement = @current_school.announcements.new(params[:announcement])    
     if @announcement.valid?
        makecall
        @announcement.label = "urgent"
        @announcement.save
        twitter = Twitter.new(@current_school.username, @current_school.password)
        twitter.post(params[:announcement][:content]) 
        redirect url(:notifications)
     else
        render :new
     end
  end
  
 # def edit
 #   @announcement = @current_school.announcement.find(params[:id])
 #   render
 # end
 # 
 # def update
 #   @announcement = @current_school.announcement.find(params[:id])
 #    if @announcement.update_attributes(params[:announcement])
 #       @announcement.label = "urgent "
 #       @announcement.save
 #       redirect resource(:notifications)
 #    else
 #       render :edit
 #    end
 #   render
 # end

 
  def delete
     @announcement = @current_school.announcements.find(params[:id])
     @announcement.destroy
     redirect resource(:notifications)
  end
  
  def makecall
     # parameters sent to Twilio REST API  
     d = {  
          'Caller' => CALLER_ID,  
          'Called' => '530 554 1373',  
          'Url' => BASE_URL + '/reminder'
         }  
      begin  
          account = TwilioRest::Account.new(ACCOUNT_SID, ACCOUNT_TOKEN)
       #  resp = account.request( "http://api.twilio.com/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls", 'POST', d)
          resp =  account.request( "/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls", 'POST', d)  
          resp.error! unless resp.kind_of? Net::HTTPSuccess  
          puts "code: %s\nbody: %s" % [resp.code, resp.body]
          puts "Eshwar"
      rescue StandardError => bang
         # render :new 
          return  
      end  
      redirect resource(:notifications)
  end
  
  def reminder  
      only_provides :xml
      @postto = BASE_URL + '/directions'  
      display @postto
  end  
  
  def directions  
     only_provides :xml
     if params['Digits'] == '3'  
        display 'goodbye'
        return  
     end  
     if !params['Digits'] or params['Digits'] != '2'  
        display 'reminder'
        return  
     end  
     @redirectto = BASE_URL + '/reminder'
     display @redirectto
  end  
  
  # TwiML response saying with the goodbye message. Twilio will detect no
  # further commands after the Say and hangup
  def goodbye
     only_provides :xml
     display 'goodbye'
  end



  private

  def access_rights
     @selected = "urgent_announcement"
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('urgent_announcement')
     @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
     @access_people.each do |f|
       have_access = (f.all == true) || (f.access_id == @ann.id)
       break if have_access
     end
     unless have_access
       redirect resource(:homes)
     end
  end
  
  
end                                                                         
