class Announcements < Application
   layout 'default'
   before :find_school
   before :classrooms
   before :rooms, :only => [:new, :edit]
   before :access_rights, :exclude => [:parent_approval, :approve_process]
   before :approval_right, :only => [:parent_approval, :approve_process ]
   
  def index
    @message1 = "Approved"
    @message2 = "Pending Approval"
    @message3 = "Rejected"
    @announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and label = ?", params[:access_name], 'staff' ])
     if params[:access_name].nil?
        @announce = @current_school.announcements.find(:all, :conditions => ['label = ?', 'staff'])
     end
     if params[:access_name] == "All Announcements"
        @all_announcements = @current_school.announcements.find(:all, :conditions => ['label = ?', 'staff'])
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
    @announcement.school_id = @current_school.id
     if @announcement.save
         unless params[:announcement][:attachment].empty?
          @attachment = Attachment.create( :attachable_type => "Announcement",
                                        :attachable_id => @announcement.id,
                                        :filename => params[:announcement][:attachment][:filename],
                                        :content_type => params[:announcement][:attachment][:content_type],
                                        :size => params[:announcement][:attachment][:size]
            )
           File.makedirs("public/uploads/#{@attachment.id}")
           FileUtils.mv(params[:announcement][:attachment][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
        end
	      redirect resource(:announcements)
     else
	      render :new
     end
  end       
  
  def edit
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def show
    @announcement = Announcement.find(params[:id])
    render
  end
  
  def update 
     @announcement = @current_school.announcements.find(params[:id])
     if @announcement.update_attributes(params[:announcement])
        Attachment.delete_all(['attachable_id = ?', @announcement.id])
        unless params[:announcement][:attachment].empty?
            @attachment = Attachment.create( :attachable_type => "Announcement",
                                        :attachable_id => @announcement.id,
                                        :filename => params[:announcement][:attachment][:filename],
                                        :content_type => params[:announcement][:attachment][:content_type],
                                        :size => params[:announcement][:attachment][:size]
            )
         end
        @announcement.person_id = session.user.id
        @announcement.approved = false
        @announcement.approve_announcement = true
        @announcement.label = 'staff'
        @announcement.school_id = @current_school.id
      	@announcement.save          
	      redirect resource(:announcements)
     else
	      render :edit
     end
  end
  
  def delete
      @announcement = Announcement.find(params[:id])
      Attachment.delete_all(['attachable_id = ?', @announcement.id])
      @announcement.destroy
      redirect resource(:announcements)
   end
   
   def preview
      @title = params[:announcement][:title]
      @content = params[:announcement][:content]
      render :layout => 'preview'
   end
   
       
   private
  
  
  def classrooms
     @class = @current_school.classrooms.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "All Announcements")
     @classrooms = room.insert(1, "Home Page")
  end
  
  def rooms
      @class = @current_school.classrooms.find(:all)
      room = @class.collect{|x| x.class_name }
      @classrooms = room.insert(0, "Home Page")
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
