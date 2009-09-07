class SpotLights < Application

  layout 'default'
  before :find_school
  before :school_people
  before :class_students
  before :access_rights, :exclude => [:spots]

  def index
     classrooms
     if params[:label] == "classes"
        @classroom = @current_school.classrooms.find_by_id(params[:id])
        @spot_lights = @current_school.spot_lights.paginate(:all, :conditions => ['class_name =?', @classroom.class_name], :order => "created_at DESC", 
                                                            :per_page => 2, :page => params[:page])
        @test = params[:id]
     elsif params[:label] == "Home Page"
        @spot_lights = @current_school.spot_lights.paginate(:all, :conditions => ['class_name =?', "Home Page"], :order => "created_at DESC", 
                                                            :per_page => 2, :page => params[:page])
        @test = "Home Page"
     else
        @spot_lights = @current_school.spot_lights.paginate(:all, :order => "created_at DESC", :per_page => 2, :page => params[:page])
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
    if @spot_light.valid?
       @spot_light.save
      if params[:spot_light][:image] != ""
         type = "spot_light"
         Attachment.picture(params.merge(:school_id => @current_school.id), type, @spot_light.id)
      end
      if @spot_light.class_name == "Home Page"
         redirect resource(:homes)
      else
         @classroom = @current_school.classrooms.find_by_class_name(@spot_light.class_name)
         redirect url(:class_details, :id => @classroom.id, :label => "spot_light")
      end
    else
      @class = params[:spot_light][:class_name]
      render :new
    end
  end
  
  def show
     @spot_light = @current_school.spot_lights.find(params[:id])
     render :layout => 'default'
  end
  
  def spots
     @selected = "spot_light"
     @select = "classrooms"
     @spot_light = @current_school.spot_lights.find(params[:id])
     @classroom = @current_school.classrooms.find_by_class_name(@spot_light.class_name)
     render :layout => 'class_change', :id => @classroom.id
  end


  def edit
    @spot_light = @current_school.spot_lights.find(params[:id])
    @pic = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
    render
  end

  def update
    @spot_light = @current_school.spot_lights.find(params[:id])
    @pic = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
    if @spot_light.update_attributes(params[:spot_light])
       if params[:spot_light][:image] != ""
          @pic = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
          unless @pic.nil?
            @pic.destroy
          end
          type = "spot_light"
          Attachment.picture(params.merge(:school_id => @current_school.id), type, @spot_light.id)
       end
       if @spot_light.class_name == "Home Page"
          redirect resource(:homes)
       else
          @classroom = @current_school.classrooms.find_by_class_name(@spot_light.class_name)
          redirect url(:class_details, :id => @classroom.id, :label => "spot_light")
       end
    else
      render :edit
    end
  end
  
  def delete
    @spot_light = @current_school.spot_lights.find(params[:id])
    @page = @spot_light.class_name
    @att = @current_school.attachments.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
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
    if params[:spot_light][:class_name] == "Home Page"
       @select = "home"
       render :layout => 'home'
    else
       @selected = "spot_light"
       @select =  "classrooms"
       @classroom = @current_school.classrooms.find(:first, :conditions => ['class_name = ?', params[:spot_light][:class_name] ])
       render :layout => 'class_change', :id => @classroom.id
    end
  end
 

  private

  def class_students
    @class = @current_school.active_classrooms
    room = @class.collect{|x| x.class_name }
    @classrooms = room.insert(0, "Home Page")
    @students = @current_school.students.find(:all, :conditions => ['activate = ?', true])
  end
  
  def classrooms
    @classes = @current_school.active_classrooms
  end
  
  def school_people
     @people = @current_school.people.find(:all, :conditions => ['activate = ?', true])
     @first_name = @people.collect{|x| x.first_name + "  " }.to_s.chop.chop
     @last_name = @people.collect{|x| x.last_name + "  " }.to_s.chop.chop
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
