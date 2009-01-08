class Homes < Application
  
    before :ensure_authenticated
    layout 'home'
    
  def index
    @date = Date.today
    @announcements = Announcement.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'Home Page', true, true], :limit => 2 )
    @from_principals = Announcement.find(:all, :conditions => ["label = ? and expiration >= ?", 'from_principal', @date], :limit => 2)
    @external_links = ExternalLink.find(:all, :conditions => ['label = ?', "Home Page"])
    render
  end
  
  def principal_articles
     @from_principals = Announcement.find(:all, :conditions => ['label = ?', 'from_principal'] )
     @announcements = Announcement.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'Home Page', true, true])
     render
  end
  
  def show
    @announcement = Announcement.find(params[:id])
    render
  end
 
  def help
    render :layout => 'help'
  end
  
end


