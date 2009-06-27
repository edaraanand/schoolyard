class SpotLights < Application

  layout 'default'
  before :find_school
  before :class_students
  before :access_rights

  def index
     classrooms
     if params[:label] == "classes"
        @classroom = @current_school.classrooms.find_by_id(params[:id])
        @spot_lights = @current_school.spot_lights.find(:all, :conditions => ['class_name =?', @classroom.class_name], :order => "created_at DESC")
        @test = params[:id]
     elsif params[:label] == "Home Page"
        @spot_lights = @current_school.spot_lights.find(:all, :conditions => ['class_name =?', "Home Page"], :order => "created_at DESC")
        @test = "Home Page"
     else
        @spot_lights = @current_school.spot_lights.find(:all, :order => "created_at DESC")
        @test = "All Spot Lights"
     end
     render
  end

  def new
    @spot_light = SpotLight.new
    render
  end

  def create
    @spot_light = @current_school.spot_lights.new(params[:spot_light])
    @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
    if ( (params[:spot_light][:class_name] != "") && (params[:spot_light][:student_name] != "") )
      if @spot_light.valid?
        if params[:spot_light][:image] != ""
          if @content_types.include?(params[:spot_light][:image][:content_type])
            @spot_light.save
            @attachment = Attachment.create( :attachable_id => @spot_light.id,
            :attachable_type => "spot_light",
            :filename => params[:spot_light][:image][:filename],
            :size => params[:spot_light][:image][:size],
            :content_type => params[:spot_light][:image][:content_type],
            :school_id => @current_school.id
            )
            File.makedirs("public/uploads/spotlights")
            FileUtils.mv(params[:spot_light][:image][:tempfile].path, "public/uploads/spotlights/#{@attachment.filename}")
            if @spot_light.class_name == "Home Page"
               redirect url(:homes)
            else
               @classroom = @current_school.classrooms.find_by_class_name(@spot_light.class_name)
               redirect url(:class_details, :id => @classroom.id, :label => "spot_light")
            end
          else
            flash[:error1] = "You can only upload images"
            render :new
          end
        else
          @spot_light.save
          @classroom = @current_school.classrooms.find_by_class_name(@spot_light.class_name)
          redirect url(:class_details, :id => @classroom.id, :label => "spot_light")
        end
      else
        render :new
      end
    else
      flash[:error] = "please select the classroom and student"
      render :new
    end

  end

  def show
    if params[:label] == "class_spot_light"
      @selected = "spot_light"
      @select = "classrooms"
      @spot_light = @current_school.spot_lights.find(params[:id])
      @classroom = @current_school.classrooms.find_by_class_name(@spot_light.class_name)
      render :layout => 'class_change', :id => @classroom.id
    else
      @spot_light = @current_school.spot_lights.find(params[:id])
      render :layout => 'default'
    end
  end


  def edit
    @spot_light = @current_school.spot_lights.find(params[:id])
    @pic = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
    render
  end

  def update
    @spot_light = @current_school.spot_lights.find(params[:id])
    @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
    @pic = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
    if params[:spot_light][:image] != ""
      if @content_types.include?(params[:spot_light][:image][:content_type])
        if ( (params[:spot_light][:class_name] != "") && (params[:spot_light][:student_name] != "") )
          if @spot_light.update_attributes(params[:spot_light])
            @pic = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
            unless @pic.nil?
              @pic.destroy
            end
            @attachment = Attachment.create( :attachable_id => @spot_light.id,
            :attachable_type => "spot_light",
            :filename => params[:spot_light][:image][:filename],
            :size => params[:spot_light][:image][:size],
            :content_type => params[:spot_light][:image][:content_type],
            :school_id =>  @current_school.id
            )
            FileUtils.mv(params[:spot_light][:image][:tempfile].path, "public/uploads/spotlights/#{@attachment.filename}")
            if @spot_light.class_name == "Home Page"
               redirect url(:homes)
            else
               @classroom = @current_school.classrooms.find_by_class_name(@spot_light.class_name)
               redirect url(:class_details, :id => @classroom.id, :label => "spot_light")
            end
          else
            render :edit
          end
        else
          flash[:error] = "please select classroom and student"
          render :edit
        end
      else
        flash[:error] = "You can only upload images"
        render :edit
      end
    else
      if ( (params[:spot_light][:class_name] != "") && (params[:spot_light][:student_name] != "") )
        if @spot_light.update_attributes(params[:spot_light])
            if @spot_light.class_name == "Home Page"
               redirect url(:homes)
            else
               @classroom = @current_school.classrooms.find_by_class_name(@spot_light.class_name)
               redirect url(:class_details, :id => @classroom.id, :label => "spot_light")
            end
        else
          render :edit
        end
      else
        flash[:error] = "please select classroom and student"
        render :edit
      end
    end
  end

  def delete
    @spot_light = @current_school.spot_lights.find(params[:id])
    @page = @spot_light.class_name
    Attachment.delete_all(['attachable_id = ?', @spot_light.id])
    @spot_light.destroy
    if @page == "Home Page"
       redirect url(:homes)
    else
       @classroom = @current_school.classrooms.find_by_class_name(@page)
       redirect url(:class_details, :id => @classroom.id, :label => "spot_light")
    end
  end

  def preview
    @student_name = params[:spot_light][:student_name]
    @content = params[:spot_light][:content]
    @class_name = params[:spot_light][:class_name]
    render :layout => 'preview'
  end



  private

  def class_students
    @class = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
    room = @class.collect{|x| x.class_name }
    @classrooms = room.insert(0, "Home Page")
    @students = Student.find(:all)
  end
  
  def classrooms
    @classes = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
  end

  def access_rights
    @selected = "spotlight"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('spotlight')
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
