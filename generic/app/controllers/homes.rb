class Homes < Application
  
    before :ensure_authenticated
    layout 'home'
    
  def index
    @announcements = Announcement.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'HomePage', true, true], :limit => 2 )
    @from_principals = Announcement.find(:all, :conditions => ['label = ?', 'from_principal'], :limit => 2 )
    render
  end
  
  def principal_articles
     @from_principals = Announcement.find(:all, :conditions => ['label = ?', 'from_principal'] )
     @announcements = Announcement.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'HomePage', true, true])
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


