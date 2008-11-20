class Homes < Application
    
    before :ensure_authenticated
    
  def index
    @announcement = Announcement.find(:first, :conditions => ['access_name =?', 'HomePage'])
    render :layout => 'home'
  end
  
end
