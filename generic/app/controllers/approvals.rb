class Approvals < Application
  
  layout 'default'
  before :classrooms, :only => [:edit, :update]
  before :ensure_authenticated
  before :access_rights
  
  def index
     @announcements = Announcement.find(:all, :conditions => ["approve_announcement = ? and approved = ?", true, false ])
     #@announcements = Announcement.find(:all, :conditions => ['label=?', 'parent'])
     render
  end
  
  def show
     @announcement = Announcement.find(params[:id])
     render :id => @announcement.id
  end
  
  def edit
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def update
     @announcement = Announcement.find(params[:id])
     if @announcement.update_attributes(params[:announcement])
        @announcement.person_id = session.user.id
        @announcement.approved = false
        @announcement.approve_announcement = true
        @announcement.label = 'parent'
        redirect resource(:approvals)
      else
        render :edit
      end
  end
  
  def publish
    @announcement = Announcement.find(params[:id])
    @announcement.approved = @announcement.approve_announcement = true
    @announcement.save 
    redirect resource(:approvals)
  end
  
  def reject
    @announcement = Announcement.find(params[:id])
    @announcement.approved = @announcement.approve_announcement = false
    @announcement.save 
    redirect resource(:approvals)
  end
  
  def preview
      @title = params[:announcement][:title]
      @content = params[:announcement][:content]
      render :layout => 'preview'
  end
  
  private
  
  def access_rights
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('approve_announcement')
     @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
     @access_people.each do |f|
       have_access = (f.all == true) || (f.access_id == @ann.id)
       break if have_access
     end
     unless have_access
       redirect resource(:homes)
     end  
  end
  
  def classrooms
     @class = Classroom.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "HomePage")
  end
  
end
