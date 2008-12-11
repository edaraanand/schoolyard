class Homes < Application
  
    before :ensure_authenticated
    layout 'home'
    
  def index
    @announcements = Announcement.find(:all, :conditions => ['access_name =?', 'HomePage'], :limit => 2 )
    @from_principals = Announcement.find(:all, :conditions => ['label = ?', 'from_principal'], :limit => 2 )
    render
  end
  
  def principal_articles
     @from_principals = Announcement.find(:all, :conditions => ['label = ?', 'from_principal'] )
     @announcements = Announcement.find(:all, :conditions => ['access_name =?', 'HomePage'] )
     render
  end
  
  def show
    @announcement = Announcement.find(params[:id])
    render
  end
 
  
end


