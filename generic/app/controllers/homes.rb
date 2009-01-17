class Homes < Application
  
    before :ensure_authenticated
    layout 'home'
    before :find_school
  
    
  def index
    @date = Date.today
    @announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ? and expiration >= ?", 'Home Page', true, true, @date], :limit => 2 )
    @from_principals = @current_school.announcements.find(:all, :conditions => ["label = ? and expiration >= ?", 'from_principal', @date], :limit => 2)
    @external_links = @current_school.external_links.find(:all, :conditions => ['label = ?', "Home Page"])
    render
  end
  
  def principal_articles
     @from_principals = @current_school.announcements.find(:all, :conditions => ['label = ?', 'from_principal'] )
     @announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'Home Page', true, true])
     render
  end
  
  def show
    @announcement = Announcement.find(params[:id])
    render
  end
 
  def help
    render :layout => 'help'
  end
  
  def download
     @attachment = Attachment.find(params[:id])
     send_file("#{Merb.root}/public/uploads/#{@attachment.id}/#{@attachment.filename}") 
  end
  
  
  
end


