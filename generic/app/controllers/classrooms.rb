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

  def create
    @classroom = @current_school.classrooms.new(params[:classroom])
    @teachers = @current_school.staff.find(:all)
    class_teacher = params[:class][:people][:class_teacher]
    @class_peoples = []
    if @classroom.valid?
      unless class_teacher == ""
        unless params[:class][:people][:roles]
          if @classroom.class_type == "Sports"
             @classroom.class_name = "Sports"
             if @classroom.valid?
               @classroom.activate = true
               @classroom.save
               ClassPeople.create({:classroom_id => @classroom.id, :person_id => "#{id}", :role => "Athletic Director"})
               redirect resource(:classrooms)
             else
               flash[:error2] = "There is already a Sports class, You can modify that"
               @id = params[:class][:people][:ids]
               @class_type = params[:classroom][:class_type]
               render :new
             end
          else
            @classroom.activate = true
            @classroom.class_name = params[:classroom][:class_name].titleize
            @classroom.save
            ClassPeople.create({:classroom_id => @classroom.id, :person_id => "#{class_teacher}", :role => "class_teacher"})
            redirect resource(:classrooms)
          end
        else
           id = params[:class][:people][:ids]
           role = params[:class][:people][:roles]
           
         unless id.include?("")
            unless role.include?("")
              if @classroom.class_type == "Sports"
                 @classroom.class_name = "Sports"
                 if @classroom.valid?
                   @classroom.activate = true
                   @classroom.save
                   @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => "#{id}", :role => "Athletic Director"})
                   s = id.zip(role)
                   s.each do |f|
                     @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => f[0], :role => f[1] })
                   end
                   redirect resource(:classrooms)
                 else
                   flash[:error2] = "There is already a Sports class, You can modify that"
                   @id = params[:class][:people][:ids]
                   @class_type = params[:classroom][:class_type]
                   render :new
                 end
              else
                 @classroom.activate = true
                 @classroom.class_name = params[:classroom][:class_name].titleize
                 @classroom.save!
                 @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => "#{class_teacher}", :role => "class_teacher"})
                 s = id.zip(role)
                 s.each do |f|
                   @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => f[0], :role => f[1] })
                 end
                 redirect resource(:classrooms)
              end
            else
              flash[:error] = "Please enter the Role"
              @id = params[:class][:people][:ids]
              @class_type = params[:classroom][:class_type]
              render :new
            end
          else
            flash[:error] = "Please select Faculty from the list"
            @id = params[:class][:people][:ids]
            @class_type = params[:classroom][:class_type]
            render :new
          end
        end
      else
        flash[:error] = "Please select Faculty from the list"
        @id = params[:class][:people][:ids]
        @class_type = params[:classroom][:class_type]
        render :new
      end
    else
      @id = params[:class][:people][:ids]
      @class_type = params[:classroom][:class_type]
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

  def update
     @classroom = @current_school.classrooms.find_by_id(params[:id])
     raise NotFound unless @classroom
     @teachers = @current_school.staff.find(:all)
     @class_peoples = @classroom.class_peoples
     if @classroom.update_attributes(params[:classroom])
        @classroom.class_name = params[:classroom][:class_name].titleize
        @classroom.save
        update_content(@classroom)
        teacher = @classroom.class_peoples.find(:first, :conditions => ['role=?', "class_teacher"] )
        athletic_director = @classroom.class_peoples.find(:first, :conditions => ['role=?', "Athletic Director"] )
        if @classroom.class_type == "Sports"
           ClassPeople.update(athletic_director.id,{:person_id => "#{params[:class][:teacher]}", :classroom_id => @classroom.id, :role => "Athletic Director" })
        else
           ClassPeople.update(teacher.id, {:person_id => "#{params[:class][:teacher]}", :classroom_id => @classroom.id, :role => "class_teacher" } )
        end
        if params[:class][:p]
           t = params[:class][:p][:roles].zip(params[:class][:p][:ids])
           t.each do |f|
              if (f[0] != "" && f[1] != "")
                 @classroom.class_peoples << ClassPeople.create({:person_id => f[1], :classroom_id => @classroom.id, :role => f[0] })
              end
           end
        end
        if params[:class][:people]
           class_people = @class_peoples.delete_if{|x| x.team_id != nil}
           class_id = class_people.delete_if{|x| x.role == "class_teacher"}.collect{|x| x.id }
           s = params[:class][:people][:r].zip(params[:class][:people][:faculty], class_id )
           s.each do |f|
             if (f[0] != "" && f[1] != "")
               @classroom.class_peoples << ClassPeople.update(f[2], {:person_id => f[1], :classroom_id => @classroom.id, :role => f[0] })
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
        @classroom.class_name = @classroom.class_name.titleize
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
         @calendars = @current_school.calendars.paginate(:all, :conditions => ['class_name = ?', @classroom.class_name.titleize], :per_page => 10, :page => params[:page], :order => 'start_date')
         @home_works = @classroom.home_works.paginate(:all, :conditions => ['school_id = ?', @current_school.id], :order => "due_date DESC", :per_page => 10, :page => params[:page])
         @announcements = @current_school.announcements.paginate(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", @classroom.class_name.titleize, true, true], :per_page => 10,
                                                              :page => params[:page], :order => "created_at DESC")
         @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name = ?', @classroom.class_name.titleize])
         @external_links = @current_school.external_links.find(:all, :conditions => ['label = ?', "Classrooms"])
         @spot_lights = @current_school.spot_lights.paginate(:all, :conditions => ['class_name = ?', @classroom.class_name], :per_page => 2, :page => params[:page], :order => 'created_at DESC')
         @ann = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", @classroom.class_name.titleize, true, true], :limit => 3, :order => "created_at DESC")
         @sp_light = @current_school.spot_lights.find(:first, :conditions => ['class_name = ?', @classroom.class_name], :order => "created_at DESC" )
         @reports = @current_school.reports.find(:all, :conditions => ['classroom_id = ?', @classroom.id])
         @ranks = @current_school.ranks.find(:all)
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
