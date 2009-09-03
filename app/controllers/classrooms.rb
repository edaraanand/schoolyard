class Classrooms < Application

  layout 'default'
  before :find_school
  before :access_rights, :exclude => [:class_details]
  before :class_types, :exclude => [:class_details]

  def index
    @classrooms = @current_school.classrooms
    render
  end

  def new
    @classroom = Classroom.new
    @teachers = @current_school.staff.find(:all)
    render
  end

  # This method is only for creating classes and subjects and not for Sports
 def create 
   @classroom = @current_school.classrooms.new(params[:classroom])
   @teachers = @current_school.staff.find(:all)
   if @classroom.valid?
      @classroom.activate = true
      @classroom.save!
      ClassPeople.create({:classroom_id => @classroom.id, :person_id => params[:class_teacher], :role => "class_teacher"})
      @class_peoples = []
      if params[:class]
         roles = params[:class][:role]
         faculty = params[:class][:faculty]
         s = roles.zip(faculty) 
         s.each do |f|
           a = f.flatten
           if ( a[1] != "")  && (a[3] != "")
             @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => a[3], :role => a[1] })
           end
         end
      end
      redirect resource(:classrooms)
   else
     render :new
   end
 end

  def edit
    @classroom = @current_school.classrooms.find_by_id(params[:id])
    raise NotFound unless @classroom
    @teachers = @current_school.staff.find(:all)
    @class_peoples = @classroom.class_peoples
    render
  end

 # Editing the classroom details only for classes and subjects and not for Sports
  def update
    @classroom = @current_school.classrooms.find_by_id(params[:id])
    raise NotFound unless @classroom
    @teachers = @current_school.staff.find(:all)
    @class_peoples = @classroom.class_peoples
    if @classroom.update_attributes(params[:classroom])
       @classroom.class_name = params[:classroom][:class_name]
       @classroom.activate = true
       @classroom.save
       update_content(@classroom)
       teacher = @classroom.class_peoples.find(:first, :conditions => ['role=?', "class_teacher"] )
       ClassPeople.update(teacher.id, {:person_id => "#{params[:class_teacher]}", :classroom_id => @classroom.id, :role => "class_teacher" } )
       if params[:class_room]
           roles = params[:class_room][:role]
           faculty = params[:class_room][:faculty]
           class_p = @class_peoples.delete_if{|x| x.team_id != nil}
           class_id = class_p.delete_if{|x| x.role == "class_teacher"}.collect{|x| x.id }
           s = roles.zip(faculty, class_id)
           s.each do |f|
             a = f.flatten
             if ( a[1] != "")  && (a[3] != "")
               @classroom.class_peoples << ClassPeople.update(a[4], {:person_id => a[3], :classroom_id => @classroom.id, :role => a[1] })
             end
           end
        end
        if params[:class]
          r = params[:class][:role]
          f = params[:class][:faculty]
          s = r.zip(f) 
          s.each do |f|
             a = f.flatten
             if ( a[1] != "")  && (a[3] != "")
               @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => a[3], :role => a[1] })
             end
          end
        end
        redirect resource(:classrooms)
    else
      render :edit
    end
  end  
  
  def delete
    if params[:label] == "remove"
      @class = ClassPeople.find(params[:id])
      @classroom = @current_school.classrooms.find_by_id(@class.classroom_id)
      @teachers = @current_school.staff.find(:all)
      @class_peoples = @classroom.class_peoples
      @class.destroy
      render :edit, :id => @classroom.id
    else
      @classroom = @current_school.classrooms.find(params[:id])
      @classroom.class_name = @classroom.class_name
      if params[:label] == "deactivate"
         @classroom.activate = false
      else
         @classroom.activate = true
      end
      @classroom.save
      redirect resource(:classrooms)
    end
  end

  def class_details
    @date = Date.today
    @selected = params[:label] #if params[:label] != nil
    @select = "classrooms"
    @classroom = @current_school.classrooms.find_by_id(params[:id])
    if @classroom
      if @classroom.activate == true
         @calendars = @current_school.calendars.paginate(:all, :conditions => ['class_name = ?', @classroom.class_name], :per_page => 10, :page => params[:page], :order => 'start_date')
         @announcements = @current_school.announcements.paginate(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", @classroom.class_name, true, true], :per_page => 10,
                                                              :page => params[:page], :order => "created_at DESC")
         @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name = ?', @classroom.class_name])
         @external_links = @current_school.external_links.find(:all, :conditions => ["label = ? and classroom_id = ?", "Classrooms", @classroom.id])
         @subject_links = @current_school.external_links.find(:all, :conditions => ["label = ? and classroom_id = ?", "Subjects", @classroom.id])
         @spot_lights = @current_school.spot_lights.paginate(:all, :conditions => ['class_name = ?', @classroom.class_name], :per_page => 2, :page => params[:page], :order => 'created_at DESC')
         @ann = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", @classroom.class_name, true, true], :limit => 3, :order => "created_at DESC")
         @sp_light = @current_school.spot_lights.find(:first, :conditions => ['class_name = ?', @classroom.class_name], :order => "created_at DESC" )
         unless @classroom.class_type == "Subject"
           @home_works = @classroom.home_works.paginate(:all, :conditions => ['school_id = ?', @current_school.id], :order => "due_date ASC", :per_page => 10, :page => params[:page])
           @reports = @current_school.reports.find(:all, :conditions => ['classroom_id = ?', @classroom.id])
           @ranks = @current_school.ranks.find(:all)
         end
         @all_class_calendars = @current_school.calendars.find(:all, :conditions => ["class_name = ? ", "Schoolwide" ], :order => 'start_date') 
         render :layout => 'class_change', :id => @classroom.id
      else
         raise NotFound
      end
    else
      raise NotFound
    end
  end

  def update_content(room)
      @classroom = room
      @announcements = @current_school.announcements.find(:all, :conditions => ['access_name = ?', @classroom.class_name] )
      @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name = ?', @classroom.class_name])
      @forms = @current_school.forms.find(:all, :conditions => ['class_name = ?', @classroom.class_name])
      @calendars = @current_school.calendars.find(:all, :conditions => ['class_name = ?', @classroom.class_name])
      @spot_lights = @current_school.spot_lights.find(:all, :conditions => ['class_name =?', @classroom.class_name] )
      @registrations = @current_school.registrations.find(:all, :conditions => ['current_class = ?', @classroom.class_name ])
      @announcements.each do |f|
        f.access_name = @classroom.class_name
        f.save
      end
      @welcome_messages.each do |f|
        f.access_name = @classroom.class_name
        f.save
      end
      @calendars.each do |f|
        f.class_name = @classroom.class_name
        f.save
      end
      @forms.each do |f|
        f.class_name = @classroom.class_name
        f.save
      end
      @spot_lights.each do |f|
        f.class_name = @classroom.class_name
        f.save
      end
      @registrations.each do |f|
        f.current_class = @classroom.class_name
        f.save
      end
   end
  
  
  private

  def access_rights
    @selected = "class_rooms"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('classes')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @access_people.each do |f|
      have_access = (f.all == true) || (f.access_id == @ann.id)
      break if have_access
    end
    unless have_access
      redirect resource(:homes)
    end
  end

  def class_types
    a = []
    type1 = a.insert(0, "Classes")
   # type2 = a.insert(1, "Sports")
    @class_types = a.insert(1, "Subject")
  end



end
