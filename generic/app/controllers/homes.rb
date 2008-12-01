class Homes < Application
    
    before :ensure_authenticated
    
  def index
    @announcements = Announcement.find(:all, :conditions => ['access_name =?', 'HomePage'], :limit => 2 )
    render :layout => 'home'
  end
  
end
