   require "twiliorest.rb"
   
  # require 'net/http'
   # require 'uri'
  
  # your Twilio authentication credentials   (Eshwar's Twilio Account )
    # ACCOUNT_SID = 'ACa1b7ee5abe50974956bda599447b1f04'  
    # ACCOUNT_TOKEN = '208232dfbc82563e6c2f9cdc54cafbe5' 
  
  # Brian's Twilio Account Details
   ACCOUNT_SID = 'ACaccbef6e62668da72003aea3ec585f89'
   ACCOUNT_TOKEN = '169a19fa5941cd4d002231beaa870b0b'
   
   # Twilio REST API version
   API_VERSION = '2008-08-01'
   
   # # base URL of this application  
   # BASE_URL = "http://sdb.#{Schoolapp.config(:app_domain)}"
   #BASE_URL = "http://sdb.schoolyardapp.net"
   
   #BASE_URL = "http://#{@current_school.subdomain}.schoolyardapp.net"
   
   # school@insightmethods.com:administration@
   # resp = account.request( "http://eshwar.gouthama@insightmethods.com:ashwini@api.twilio.com/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls", 'POST', d)
   #https://username:password@api.twilio.com/2008-08-01 ..
    
   # Outgoing Caller ID you have previously validated with Twilio  
    # CALLER_ID = '(415) 287-0729'  
     CALLER_ID = '530 554 1373'
   # CALLED = '530 554 1373' Myself
   
   # CALLED = '5713320672' AJ
   # CALLED = ' 530-756-8158' Brian
   # CALLED = '+14152870729' Niket
     #CALLED = '530 554 1373' Eshwar

class Notifications < Application
   layout 'default'
   before :access_rights, :exclude => [:reminder, :directions, :goodbye] 
   before :find_school
   provides :html, :xml
   
   
   
   
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
        @announcement.access_name = "Home Page"
        @announcement.label = "urgent"
        content = format(params[:announcement][:content])
        @announcement.content = content
        @announcement.save!
        makecall(@announcement.id)
        twitter = Twitter.new(@current_school.username, @current_school.password)
        twitter.post(params[:announcement][:content])
        @people = @current_school.people.find(:all)
        numbers = @people.collect{ |x| x.sms_alert }
        eee = numbers.compact
        num = eee.delete_if{|x| x == ""}
        number = num.collect{|x| "1" + x }
        @num = number.join(',')
        unless @num.empty?
           api = Clickatell::API.authenticate('3175693', 'brianbolz', 'brianbolz1')
           api.send_message("#{@num}", "#{@announcement.content}")
        end 
        run_later do
          @announcement.mail(:urgent_announcement, :subject => "Urgent Announcement for " + @current_school.school_name)
        end
        redirect resource(:homes)
     else
        render :new                
     end 
  end
  
  def delete
      @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
     @announcement.destroy
     redirect url(:homes)
  end
  
  def makecall(id)
    @announcement = @current_school.announcements.find_by_id(id)
    @people = @current_school.people.find(:all)
    @people.each do |f|
        unless f.voice_alert.blank?
             begin  
                 account = TwilioRest::Account.new(ACCOUNT_SID, ACCOUNT_TOKEN)
                 resp =  account.request( "/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls.csv", 'POST',
                                               d = { 'Caller' => CALLER_ID,
                                                     'Called' => "#{f.voice_alert}",
                                                     'Url' => "http://#{@current_school.subdomain}.#{Schoolapp.config(:app_domain)}" + "/reminder?id=#{@announcement.id}" }  )
                 Merb.logger.info "Checking the Log For #{@resp.body}"                                    
                 resp.error! unless resp.kind_of? Net::HTTPSuccess  
             rescue StandardError => bang
                 return  
             end  
        end
    end
    redirect resource(:notifications)
  end
   
  def reminder  
     only_provides :xml
     @announcement = @current_school.announcements.find_by_id(params[:id])
     @postto = "http://#{@current_school.subdomain}.#{Schoolapp.config(:app_domain)}" + "/directions?id=#{@announcement.id}"  
     display @postto, :layout => false
  end  
  
  def directions  
     @announcement = @current_school.announcements.find_by_id(params[:id])
     if params['Digits'] == '1' 
        redirect url(:reminder, :id => @announcement.id)
     else
        redirect url(:goodbye)
     end
  end  
  
  # TwiML response saying with the goodbye message. Twilio will detect no
  # further commands after the Say and hangup
  def goodbye
     only_provides :xml
     display 'goodbye', :layout => false
  end
  
  def format(str)
    the_str = str.to_s
    the_str = the_str.gsub(/[^a-zA-Z0-9-]/, " ")
    the_str
  end
  
  def twilio_log
     account = TwilioRest::Account.new(ACCOUNT_SID, ACCOUNT_TOKEN)
     resp =  account.request("/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls?num=500&page=5.csv", "GET" )
     filename = "twilio.csv"
     q = 1
     csv_string = FasterCSV.generate do |csv|
        csv << ["Date", "Caller", "Called", "Status"]
        resp.body.each do |row|
           unless q == 1
             l = row.gsub("\r\n", " ").split(',')
             if l[10] == "1"
                status = "In progress"
             elsif l[10] == "2"
                status = "completed"
             elsif l[10] == "3"
                status = "Failed - Busy"
             elsif l[10] == "4"
                status = "Failed - Application Error"
             elsif l[10] == "5"
                status = "Failed - No Answer"
             end
             date = l[1] + l[2]
             csv << [date, l[8], l[7], status]
           end
           q += 1
        end
     end
     send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
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
