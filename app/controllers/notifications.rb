class Notifications < Application
   layout 'default'
   before :access_rights, :exclude => [:reminder, :directions, :goodbye] 
   before :find_school
   before :get_logs, :only => [:index]
   before :status_messages
   before :sms_status_codes, :only => [:sms_log_details]
   provides :html, :xml
      
  def index
    twilio_status
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

        post_urgent_announcement_later(@announcement.id)

        redirect resource(:homes)
     else
        render :new                
     end 
  end
  
  def show
    @announcement = @current_school.announcements.find_by_id(params[:id]) rescue NotFound     
    log_details(@announcement.id)
    render
  end
  
  def sms_log_details
    @announcement = @current_school.announcements.find_by_id(params[:id]) rescue NotFound 
    status_codes = []
    sms_people = []
    sms_report = []
    people = []
    @sms_codes = @current_school.logs.find(:all, :select => 'sms_code, person_id', :conditions => ["announcement_id = ?", @announcement.id ])
    api = Clickatell::API.authenticate(Schoolapp.config(:clickatell_api), Schoolapp.config(:clickatell_user), Schoolapp.config(:clickatell_password))
    @sms_codes.each do |f|
      unless f.sms_code.nil?
        status_codes <<  api.message_status("#{f.sms_code}")
        sms_people << f.person_id
      end
    end
    details = status_codes.zip(sms_people)
    details.each do |f|
       if @@reports.has_value?("#{f[0]}")
          l = @@reports.index("#{f[0]}")
       end
       if @@msgs.has_value?("#{f[0]}")
          t = @@msgs.index("#{f[0]}")
       end
       if @@sms.has_key?(t)
          status = @@sms[t] 
       end
       if @@sms.has_key?(l)
          status = @@sms[l] 
       end
       sms_report << status
       people << "#{f[1]}"
    end
    @sms_details = sms_report.zip(people)
    render
  end
  
  def delete
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    @announcement.destroy
    redirect url(:homes)
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
     filename = "announcement.csv"
     p = []
     s = []
     @logs = @current_school.logs.find(:all)
     @logs.each do |f|
       @@log_twilio.each do |t|
           if t[0] == f.twilio_call_id
              p << t[1]
              s << t[2]
           end
       end                                                          
     end
     ss = p.zip(s, @@dates)
     csv_string = FasterCSV.generate do |csv|
         csv << ["Date", "Caller", "Called", "Status"]
         ss.each do |u|
            if @@message_report.has_value?(u[1])
              u[1] = @@message_report.index(u[1])
            end
            if @@status_reports.has_key?(u[1])
              status = @@status_reports[u[1]] 
            end
            csv << [u[2], "5305541373", u[0], status]
         end   
     end
     send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
  end
 
  def twilio_status
     @announcements = @current_school.announcements.paginate(:all,
                                                             :conditions => ['label=?', "urgent"],
                                                             :per_page => 10,
                                                             :page => params[:page] )
     @announcements.each do |announcement| 
       log_details(announcement.id)
     end
  end
  
  def log_details(id)
    phones = []
    status = []
    @logs = @current_school.logs.find(:all, :conditions => ["announcement_id = ?", id])  
    @logs.each do |f| 
      @@log_twilio.each do |t|
        if t[0] == f.twilio_call_id
           phones << t[1]
           status << t[2]
        end
      end                                                          
    end
    @completed = status.select{|x| x == "2" } 
    @p = phones.zip(status)
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
  
  def get_logs
     account = TwilioRest::Account.new(Schoolapp.config(:twilio_account_id), Schoolapp.config(:twilio_account_token))
     @@resp =  account.request("/#{Schoolapp.config(:twilio_api_version)}/Accounts/#{Schoolapp.config(:twilio_account_id)}/Calls?num=500&page=5.csv", "GET" )
     @@twilio_ids = []
     @@twilio_phones = []
     @@twilio_status = []
     @@dates = []
     q = 1
     @@resp.body.each do |row|
        unless q == 1
          l = row.gsub("\r\n", " ").split(',')
          @@twilio_ids << l[0]
          @@twilio_phones << l[7]
          @@twilio_status << l[10]
          @@dates << l[1] + l[2]
        end
        q += 1
     end
     @@log_twilio = @@twilio_ids.zip(@@twilio_phones, @@twilio_status)
  end
  
  def status_messages
     @@status_reports  =  { :a => "Not Yet Dialed", :b => "In Progress",
                            :c => "Complete", :d => "Failed - Busy", 
                            :e => "Failed - Application Error", :f => "Failed - No Answer" } 
   
     @@message_report  =  { :a => "0", :b => "1",
                            :c => "2", :d => "3", 
                            :e => "4", :f => "5" }
  end
  
  def sms_status_codes
    @@sms = { :a => "Message unknown", :b => "Message queued", :c => "Delivered to gateway", :d => "Received by recipient", 
              :e => "Error with message", :f => "User cancelled message delivery", :g => "Error delivering message",
              :h => "OK", :i => "Routing error", :j => "Message queued for later delivery",
              :k => "Out of credit"  }
              
    @@msgs =  { :a => "001", :b => "002", :c => "003", :d => "004", 
                :e => "005", :f => "006", :g => "007", :h => "008",
                :i => "009", :j => "010", :k => "011" }
                   
    @@reports =  { :a => "1", :b => "2", :c => "3", :d => "4", 
                    :e => "5", :f => "006", :g => "7", :h => "8",
                    :i => "9", :j => "10", :k => "11" }
    
  end
 
end                                                                         
