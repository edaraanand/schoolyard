class Parents < Application
  
  layout 'home'
  
  before :ensure_authenticated
  before :classroom
  
 
  def index
    @announcements = session.user.announcements
    @message1 = "Approved"
    @message2 = "Pending Approval"
    @message3 = "Rejected"
    render
  end
  
  def new
    @announcement = Announcement.new
    render
  end
  
  def show
    @announcement = Announcement.find(params[:id])
    render
  end
  
  def create
    @announcement = session.user.announcements.build(params[:announcement])
    @announcement.approved = false
    @announcement.approve_announcement = true
    @announcement.label = 'parent'
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
        redirect resource(:parents)
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
        @announcement.label = 'parent'
      	@announcement.save          
	      redirect resource(:parents)
     else
	      render :edit
     end
  end
  
  def delete
      Announcement.find(params[:id]).destroy
      redirect resource(:parents)
  end
   
   def preview
      @title = params[:announcement][:title]
      @content = params[:announcement][:content]
      render :layout => 'preview'
   end
  
  private
  
  def classroom
     @class = Classroom.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "HomePage")
  end
    
end
