class FromPrincipals < Application

  layout 'default'
  before :find_school
  before :access_rights
  before :titles, :only => [:new_settings, :create_settings, :edit_details, :update_details]

  def index
    @announcements = @current_school.announcements.paginate(:all,
                                                            :conditions => ['label=?', "from_principal"],
                                                            :order => "created_at DESC",
                                                            :per_page => 10,
                                                            :page => params[:page] )
    render
  end

  def new
    @announcement = Announcement.new
    render
  end

  def create
    @announcement = @current_school.announcements.new(params[:announcement])
    i=0
    if @announcement.valid?
       @announcement.label = "from_principal"
       @announcement.save
       unless params[:attachment]['file_'+i.to_s].empty?
         type = "Announcement"
         @attachment = Attachment.file(params.merge(:school_id => @current_school.id), type, @announcement.id)
       end
       email_alerts(@announcement.id, self.class, @announcement, @current_school)
       redirect url(:homes)
    else
      render :new
    end
  end

  def edit
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    @attachments = Attachment.announcements(@announcement.id, @current_school.id)
    @allowed = 1 - @attachments.size
    render
  end

  def update
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    @attachments = Attachment.announcements(@announcement.id, @current_school.id)
    @allowed = 1 - @attachments.size
    i=0
    if @announcement.update_attributes(params[:announcement])
       @announcement.label = "from_principal"
       @announcement.save
       if params[:attachment]
          unless params[:attachment]['file_'+i.to_s].empty?
            type = "Announcement"
            @attachment = Attachment.file(params.merge(:school_id => @current_school.id), type, @announcement.id)
          end
       end
       redirect resource(:homes)
    else
      render :edit
    end
  end
  
  def show
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    render
  end

  def delete
    if params[:label] == "attachment"
      @attachment = @current_school.attachments.find(params[:id])
      @announcement = @current_school.announcements.find_by_id(@attachment.attachable_id)
      @attachment.destroy
      @attachments = Attachment.announcements(@announcement.id, @current_school.id)
      @allowed = 1 - @attachments.size
      render :edit, :id => @announcement.id
    else
      @announcement = @current_school.announcements.find_by_id(params[:id])
      raise NotFound unless @announcement
      Attachment.delete_all(['attachable_id = ?', @announcement.id])
      @announcement.destroy
      redirect url(:homes)
    end
  end

  def preview
    @date = Date.today
    @select = "home"
    render :layout => 'home'
  end

  def settings
    @attachment = @current_school.attachments.find_by_attachable_type("principal_image")
    p = @current_school.principal_id
    @principal = @current_school.staff.find_by_id(p)
    render
  end

  def settings_update
    @staff = @current_school.staff.find_by_id(params[:school_principal])
    @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
    @current_school.principal_id = @staff.id
    if @staff && @current_school.save!
       if params[:image][:filename] != nil
          picture = @current_school.attachments.find_by_attachable_type("principal_image")
          picture.destroy if picture
          Attachment.picture(params.merge(:school_id => @current_school.id), "principal_image", 0)
       end
       if params[:principal_email]
          @staff.principal_email = true
       else
          @staff.principal_email = false if @staff
       end
       if params[:principal_name]
          @staff.principal_name = true
       else
          @staff.principal_name = false if @staff
       end
       @staff.save
       redirect url(:settings)
    else
       render :settings
    end
    
  end
 
 
  private

  def access_rights
    @selected = "from_principal"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('from_principal')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @access_people.each do |f|
      have_access = (f.all == true) || (f.access_id == @ann.id)
      break if have_access
    end
    unless have_access
      redirect resource(:homes)
    end
  end


  def titles
    a = []
    t1 = a.insert(0, "Mr.")
    t2 = a.insert(1, "Mrs.")
    t3 = a.insert(2, "Ms.")
    @titles = a.insert(3, "Dr.")
  end


end
