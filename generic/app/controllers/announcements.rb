class Announcements < Application
   layout 'default'
   before :classrooms
   before :access_rights, :exclude => [:parent_approval, :approve_process]
   before :approval_right, :only => [:parent_approval, :approve_process ]
   
  def index
    @message1 = "Approved"
    @message2 = "Pending Approval"
    @message3 = "Rejected"
    @announcements = Announcement.find(:all, :conditions => ["access_name = ? and label = ?", params[:access_name], 'staff' ])
     if params[:access_name].nil?
       @announce = Announcement.find(:all, :conditions => ['label = ?', 'staff'])
     end
     render
  end
  
  def new
     @announcement = Announcement.new
     render 
  end
  
  def create
    @announcement = session.user.announcements.build(params[:announcement])
    @announcement.approved = false
    @announcement.approve_announcement = true
    @announcement.label = 'staff'
     if @announcement.save
	      redirect resource(:announcements)
     else
	      render :new
     end
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
        @announcement.label = 'staff'
      	@announcement.save          
	      redirect resource(:announcements)
     else
	      render :edit
     end
  end
  
  def delete
      Announcement.find(params[:id]).destroy
      redirect resource(:announcements)
   end
   
   def preview
      @title = params[:announcement][:title]
      @content = params[:announcement][:content]
      render :layout => 'preview'
   end
   
       
   private
  
  
  def classrooms
     @class = Classroom.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "HomePage")
  end
  
  def access_rights
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('announcements')
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
