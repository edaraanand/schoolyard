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
        @attachment = Attachment.create( :attachable_type => "Announcement",
        :attachable_id => @announcement.id,
        :filename => params[:attachment]['file_'+i.to_s][:filename],
        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
        :size => params[:attachment]['file_'+i.to_s][:size],
        :school_id =>  @current_school.id
        )
       File.makedirs("public/uploads/#{@current_school.id}/files")
       FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@current_school.id}/files/#{@attachment.id}")
      end
      email_alerts(@announcement.id, self.class, @announcement, @current_school)
      redirect url(:homes)
    else
      render :new
    end
  end

  def edit
    @announcement = @current_school.announcements.find(params[:id])
    @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
    @allowed = 1 - @attachments.size
    render
  end

  def update
    @announcement = @current_school.announcements.find(params[:id])
    @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
    @allowed = 1 - @attachments.size
    i=0
    if params[:attachment]
      if @announcement.update_attributes(params[:announcement])
        @announcement.label = "from_principal"
        @announcement.save
        unless params[:attachment]['file_'+i.to_s].empty?
          @attachment = Attachment.create( :attachable_type => "Announcement",
          :attachable_id => @announcement.id,
          :filename => params[:attachment]['file_'+i.to_s][:filename],
          :content_type => params[:attachment]['file_'+i.to_s][:content_type],
          :size => params[:attachment]['file_'+i.to_s][:size],
          :school_id =>  @current_school.id
          )
          File.makedirs("public/uploads/#{@current_school.id}/files")
          FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@current_school.id}/files/#{@attachment.id}")
        end
         redirect url(:homes)
      else
        render :edit
      end
    else
      if @announcement.update_attributes(params[:announcement])
         @announcement.label = "from_principal"
         @announcement.save
         redirect url(:homes)
      else
        render :edit
      end
    end
  end

  def show
    @announcement = @current_school.announcements.find(params[:id])
    render
  end

  def delete
    if params[:label] == "attachment"
      @attachment = @current_school.attachments.find(params[:id])
      @announcement = @current_school.announcements.find_by_id(@attachment.attachable_id)
      @attachment.destroy
      @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
      @allowed = 1 - @attachments.size
      render :edit, :id => @announcement.id
    else
      @announcement = @current_school.announcements.find(params[:id])
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
    @principal = Principal.find(:first, :conditions => ['school_id = ?', @current_school.id])
    @attachment = @current_school.attachments.find(:first, :conditions => ['attachable_type = ?', "principal_image"])
    render
  end

  def new_settings
    @pr = Principal.find(:first, :conditions => ['school_id = ?', @current_school.id])
    if @pr.nil?
       @principal = Principal.new
       render
    else
      raise NotFound
    end
  end

  def create_settings
    @principal = Principal.new(params[:principal])
    if @principal.valid?
       @principal.school_id = @current_school.id
       @principal.save!
       redirect url(:settings)
    else
      render :new_settings
    end
  end

  def edit_details
    @principal = Principal.find(:first, :conditions => ['school_id = ?', @current_school.id])
    render
  end

  def update_details
    @principal = Principal.find(:first, :conditions => ['school_id = ?', @current_school.id])
    if @principal.update_attributes(params[:principal])
       redirect url(:settings)
    else
       render :edit_details
    end
  end

  def settings_update
    @principal = Principal.find(:first, :conditions => ['school_id = ?', @current_school.id])
    @attachment = @current_school.attachments.find(:first, :conditions => ['attachable_type = ?', "principal_image"])
    @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
    if params[:image][:filename] != nil
      if @content_types.include?(params[:image][:content_type])
        unless @attachment.nil?
          @attachment.destroy
        end
        f = params[:image][:filename]
        file = File.basename(f.gsub(/\\/, '/'))
        @attachment = Attachment.create( :attachable_type => "principal_image",
                                         :filename => file,
                                         :content_type => params[:image][:content_type],
                                         :size => params[:image][:size],
                                         :school_id => @current_school.id
                                       )
        unless @principal.nil?
          if ((params[:principal_email] == "on") || (params[:principal_name] == "on") )
            if params[:principal_name] == "on"
              @principal.principal_name = true
              @principal.principal_email = false
            end
            if params[:principal_email] == "on"
              @principal.principal_email = true
              @principal.principal_name = false
            end
            if (params[:principal_email]) && (params[:principal_name])
              @principal.principal_email = true
              @principal.principal_name = true
            end
          else
            @principal.principal_email = false
            @principal.principal_name = false
            @principal.save
          end
          @principal.save
        end
        File.makedirs("public/uploads/#{@current_school.id}/pictures")
        FileUtils.mv(params[:image][:tempfile].path, "public/uploads/#{@current_school.id}/pictures/#{@attachment.id}")
        redirect url(:homes)
      else
        flash[:error1] = "You can only upload images"
        render :settings
      end
    else
      unless @principal.nil?
        if ((params[:principal_email] == "on") || (params[:principal_name] == "on") )
          if params[:principal_name] == "on"
            @principal.principal_name = true
            @principal.principal_email = false
          end
          if params[:principal_email] == "on"
            @principal.principal_email = true
            @principal.principal_name = false
          end
          if (params[:principal_email]) && (params[:principal_name])
            @principal.principal_email = true
            @principal.principal_name = true
          end
          @principal.save
        else
          @principal.principal_email = false
          @principal.principal_name = false
          @principal.save
        end
      end
      redirect url(:homes)
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
