class Homes < Application
    
    before :ensure_authenticated
    
  def index
    @view = Access.find_by_name('view_all')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @announcement = Announcement.find(:first, :conditions => ['access_name =?', 'HomePage'])
    render :layout => 'home'
  end
  
end
