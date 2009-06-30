class WelcomeMessages < Application

  layout 'default'
  before :find_school
  before :rooms, :only => [:new, :create, :edit, :update]
  before :access_rights


  def index
    classrooms
    if params[:label] == "classes"
       @classroom = @current_school.classrooms.find_by_id(params[:id])
       @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name =?', @classroom.class_name], :order => "created_at DESC")
       @test = params[:id]
    elsif params[:label] == "Home Page"
       @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name =?', "Home Page"], :order => "created_at DESC")
       @test = "Home Page"
    else
       @welcome_messages = @current_school.welcome_messages.find(:all, :order => "created_at DESC")
       @test = "All Messages"
    end
      render
  end

  def new
    @welcome_message = WelcomeMessage.new
    render
  end

  def create
    @welcome_message = @current_school.welcome_messages.new(params[:welcome_message])
    if params[:welcome_message][:access_name] != ""
       @welcome_message.person_id = @current_user.id
      if @welcome_message.save
         if @welcome_message.access_name == "Home Page"
            redirect url(:homes)
         else
            @classroom = @current_school.classrooms.find_by_class_name(@welcome_message.access_name)
            redirect url(:class_details, :id => @classroom.id)
         end
      else
        render :new
      end
    else
      flash[:error] = "Please select the option"
      render :new
    end
  end

  def edit
    @welcome_message = @current_school.welcome_messages.find(params[:id])
    ss = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
    om = ss.collect{|x| x.class_name.titleize }
    @test = om.insert(0, "Home Page")
    render
  end

  def update
    @welcome_message = @current_school.welcome_messages.find(params[:id])
    if params[:welcome_message][:access_name] != ""
      if @welcome_message.update_attributes(params[:welcome_message])
         @welcome_message.person_id = @current_user.id
         if @welcome_message.access_name == "Home Page"
            redirect resource(:homes)
         else
           @classroom = @current_school.classrooms.find_by_class_name(@welcome_message.access_name)
           redirect url(:class_details, :id => @classroom.id )
         end
      else
        render :edit
      end
    else
      flash[:error] = "Please select the option"
      render :edit
    end
  end

  def delete
    @welcome_message = @current_school.welcome_messages.find(params[:id])
    @page = @welcome_message.access_name
    @welcome_message.destroy
    if @welcome_message.access_name == "Home Page"
        redirect resource(:homes)
    else
       @classroom = @current_school.classrooms.find_by_class_name(@page)
       redirect url(:class_details, :id => @classroom.id )
    end
  end

  def preview
    if params[:welcome_message][:access_name] == "Home Page"
      @select = "home"
      render :layout => "home"
    else
      @select = "classrooms"
      @selected = nil
      @classroom = @current_school.classrooms.find_by_class_name(params[:welcome_message][:access_name])
      render :layout => 'class_change', :id => @classroom.id
    end
  end

  private

  def classrooms
    @classes = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
  end

  def rooms
    @class = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
    room = @class.collect{|x| x.class_name }
    @classrooms = room.insert(0, "Home Page")
    @messages = @current_school.welcome_messages.find(:all)
    if @messages.empty?
      @eee = @classrooms
    else
      @messages.each do |f|
        if @classrooms.include?(f.access_name)
          @eee = @classrooms.delete_if{|x| x == f.access_name}
        else
          @eee =  @classrooms
        end
      end
    end
  end

  def access_rights
    @selected = "welcome_messages"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('welcome_messages')
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
