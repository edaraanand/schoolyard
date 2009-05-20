   require "twiliorest.rb"
  
   # your Twilio authentication credentials  
   ACCOUNT_SID = 'ACa1b7ee5abe50974956bda599447b1f04'  
   ACCOUNT_TOKEN = '208232dfbc82563e6c2f9cdc54cafbe5' 
   
   # Twilio REST API version
   API_VERSION = '2008-08-01'
   
   # # base URL of this application  
   BASE_URL = "http://sdb.#{Schoolapp.config(:app_domain)}" 
     
   # Outgoing Caller ID you have previously validated with Twilio  
   CALLER_ID = 'NNNNNNNNNN'  
   CALLED = '571 332 0672'
   

class Notifications < Application
   layout 'default'
   before :access_rights 
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
        raise "Naidu".inspect
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
      #raise "hip".inspect
     # parameters sent to Twilio REST API  
     d = {  
          'Caller' => CALLER_ID,  
          'Called' => '571 332 0672',  
          'Url' => BASE_URL + '/reminder'
         }  
      begin  
          account = TwilioRest::Account.new(ACCOUNT_SID, ACCOUNT_TOKEN)
          puts account.inspect
          puts "indu".inspect
          resp = account.request(  
              "/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls",  
              'POST', d)  
          puts resp.inspect
          resp.error! unless resp.kind_of? Net::HTTPSuccess  
      rescue StandardError => bang  
          render :new 
          #return  
      end  
        
     # redirect_to({ :action => '',   
     #     'msg' => "Calling #{ params['number'] }..." })  
     redirect resource(:notifications)
  end
  
  def reminder  
      @postto = BASE_URL + '/directions'  
      
      respond_to do |format|  
          format.xml { @postto }  
      end  
  end  
  
  def directions  
      if params['Digits'] == '3'  
         redirect_to :action => 'goodbye'  
         return  
      end  
        
      if !params['Digits'] or params['Digits'] != '2'  
         redirect_to :action => 'reminder'  
         return  
      end  
        
      @redirectto = BASE_URL + '/reminder',  
      respond_to do |format|  
          format.xml { @redirectto }  
      end  
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
