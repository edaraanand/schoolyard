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
   BASE_URL = "http://sdb.schoolyardapp.net"
   
   #school@insightmethods.com:administration@
   #resp = account.request( "http://eshwar.gouthama@insightmethods.com:ashwini@api.twilio.com/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls", 'POST', d)
   #https://username:password@api.twilio.com/2008-08-01 ..
    
   # Outgoing Caller ID you have previously validated with Twilio  
    # CALLER_ID = '(415) 287-0729'  
     CALLER_ID = '530 554 1373'
   # CALLED = '530 554 1373' Myself
   
   # CALLED = '571 332 0672' AJ
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
        @announcement.label = "urgent"
        @announcement.save!
        #makecall(@announcement.id)
        #twitter = Twitter.new(@current_school.username, @current_school.password)
        #twitter.post(params[:announcement][:content])
        #run_later do
        #  @people = @current_school.people.find(:all)
        #  numbers = @people.collect{ |x| x.sms_alert }
        #  num     = numbers.compact.join(',')
        #  @sms_numbers = num.collect{ |x| "1" + x }
        #api = Clickatell::API.authenticate('3175693', 'brianbolz', 'MupanoOCMLGLxHTdrQlIDY5tgMXoOeausulUjzIMNtsas6Bvvu')
        #  t = api.auth_options[:session_id]
        #  s = Net::HTTP.get_response(URI.parse("http://api.clickatell.com/http_batch/startbatch?session_id=#{t}&template=#{@announcement.content}"))
        #  id = s.body.split
        #  id.each do |f|
        #     if f != "ID:"
        #        r = Net::HTTP.get_response(URI.parse("http://api.clickatell.com/http_batch/quicksend?session_id=#{t}&batch_id=#{f}&to=#{@sms_numbers}&template='#{@announcement.content}'"))
        #     end
        #   end
        #end
       # @people = @current_school.people.find(:all)
       # numbers = @people.collect{ |x| x.sms_alert }
       # num     = numbers.compact.join(',')
       # @sms_numbers = num.collect{ |x| "1" + x }
       # @sms_numbers = ['15713320672', '14158899280'].join(',')
        #api.send_message("#{@sms_numbers}", "#{@announcement.content}")
        #run_later do
        #   @announcement.mail(:urgent_announcement, :subject => "Urgent Announcement for " + @current_school.school_name)
        #end
        #num = ['14158899280', '15713320672', '919998805789', '919227587555', '919998805789'].join(',')
        redirect url(:homes)
     else
        render :new                
     end 
  end
  
  def delete
     @announcement = @current_school.announcements.find(params[:id])
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
                                                     'Url' => BASE_URL + "/reminder?id=#{@announcement.id}" }  )
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
     @postto = BASE_URL + "/directions?id=#{@announcement.id}"  
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
