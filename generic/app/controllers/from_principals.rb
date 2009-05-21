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
        :size => params[:attachment]['file_'+i.to_s][:size]
        )
        File.makedirs("public/uploads/#{@attachment.id}")
        FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
      end
      redirect resource(:from_principals)
    else
      render :new
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
    @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
    @allowed = 1 - @attachments.size
    render
  end

  def update
    @announcement = Announcement.find(params[:id])
    @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
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
          :size => params[:attachment]['file_'+i.to_s][:size]
          )
          File.makedirs("public/uploads/#{@attachment.id}")
          FileUtils.mv(params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
        end
        redirect resource(:from_principals)
      else
        render :edit
      end
    else
      if @announcement.update_attributes(params[:announcement])
        @announcement.label = "from_principal"
        @announcement.save
        redirect resource(:from_principals)
      else
        render :edit
      end
    end
  end

  def show
    @announcement = Announcement.find(params[:id])
    render
  end

  def delete
    if params[:label] == "attachment"
      @attachment = Attachment.find(params[:id])
      @announcement = Announcement.find_by_id(@attachment.attachable_id)
      @attachment.destroy
      @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
      @allowed = 1 - @attachments.size
      render :edit, :id => @announcement.id
    else
      @announcement = Announcement.find(params[:id])
      Attachment.delete_all(['attachable_id = ?', @announcement.id])
      @announcement.destroy
      redirect resource(:from_principals)
    end
  end

  def preview
    @date = Date.today
    @select = "home"
    render :layout => 'home'
  end

  def settings
    @principal = Principal.find(:first)
    @attachment = Attachment.find(:first, :conditions => ['attachable_type = ?', "principal_image"])
    render
  end

  def new_settings
    @pr = Principal.find(:first)
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
      @principal.save
      redirect url(:settings)
    else
      render :new_settings
    end
  end

  def edit_details
    @principal = Principal.find(:first)
    render
  end

  def update_details
    @principal = Principal.find(:first)
    if @principal.update_attributes(params[:principal])
      redirect url(:settings)
    else
      render :edit_details
    end
  end

  def settings_update
    @principal = Principal.find(:first)
    @attachment = Attachment.find(:first, :conditions => ['attachable_type = ?', "principal_image"])
    @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
    if params[:image][:filename] != nil
      if @content_types.include?(params[:image][:content_type])
        unless @attachment.nil?
          @attachment.destroy
        end
        @attachment = Attachment.create( :attachable_type => "principal_image",
        :filename => params[:image][:filename],
        :content_type => params[:image][:content_type],
        :size => params[:image][:size]
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
        File.makedirs("public/uploads/principal_images")
        FileUtils.mv(params[:image][:tempfile].path, "public/uploads/principal_images/#{@attachment.filename}")
        redirect url(:settings)
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
      redirect url(:settings)
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
