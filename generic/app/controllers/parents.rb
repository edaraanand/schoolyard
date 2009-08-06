class Parents < Application

  layout 'home'
  before :find_school
  before :ensure_authenticated
  before :classroom
  before :tab_select


  def index
    @announcements = session.user.announcements.paginate(:all, 
                                                         :conditions => ['school_id = ?', @current_school.id], :per_page => 5, 
                                                         :page => params[:page] )
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
    @announcement = session.user.announcements.find(params[:id])
    render
  end

  def create
    @announcement = session.user.announcements.build(params[:announcement])
    @announcement.approved = false
    @announcement.approve_announcement = true
    @announcement.label = 'parent'
    @announcement.school_id = @current_school.id
    if @announcement.save
      unless params[:announcement][:attachment].empty?
        @attachment = Attachment.create( :attachable_type => "Announcement",
        :attachable_id => @announcement.id,
        :filename => params[:announcement][:attachment][:filename],
        :content_type => params[:announcement][:attachment][:content_type],
        :size => params[:announcement][:attachment][:size],
        :school_id => @current_school.id
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
    @announcement = session.user.announcements.find(params[:id])
    render
  end

  def update
    @announcement = session.user.announcements.find(params[:id])
    if @announcement.update_attributes(params[:announcement])
      Attachment.delete_all(['attachable_id = ?', @announcement.id])
      unless params[:announcement][:attachment].empty?
        @attachment = Attachment.create( :attachable_type => "Announcement",
        :attachable_id => @announcement.id,
        :filename => params[:announcement][:attachment][:filename],
        :content_type => params[:announcement][:attachment][:content_type],
        :size => params[:announcement][:attachment][:size],
        :school_id => @current_school.id
        )
      end
      @announcement.person_id = session.user.id
      @announcement.approved = false
      @announcement.approve_announcement = true
      @announcement.label = 'parent'
      @announcement.school_id = @current_school.id
      @announcement.save
      redirect resource(:parents)
    else
      render :edit
    end
  end

  def delete
    @announcement = session.user.announcements.find(params[:id])
    Attachment.delete_all(['attachable_id = ?', @announcement.id])
    @announcement.destroy
    redirect resource(:parents)
  end

  def preview
    @date = Date.today
    if params[:announcement][:access_name] == "Home Page"
       @select = "home"
       render :layout => 'home'
    else
       @selected = "announcements"
       @select =  "classrooms"
       @classroom = @current_school.classrooms.find(:first, :conditions => ['class_name = ?', params[:announcement][:access_name] ])
       render :layout => 'class_change', :id => @classroom.id
    end
  end

  private

  def classroom
    @class = @current_school.classrooms.find(:all)
    room = @class.collect{|x| x.class_name }
    @classrooms = room.insert(0, "Home Page")
  end

  def tab_select
    @select = "parent_announcements"
  end

end
