class Classrooms < Application

  layout 'default'
  before :find_school
  before :access_rights, :exclude => [:class_details]
  before :class_types, :exclude => [:class_details]

  def index
    @classrooms = @current_school.classrooms.find(:all)
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
    id = params[:class][:people][:ids]
    role = params[:class][:people][:role]
    teachers = params[:class][:people][:teacher]
    @class_peoples = []
    if @classroom.valid?
      unless id.include?("please")
        if role.nil?
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
            ClassPeople.create({:classroom_id => @classroom.id, :person_id => "#{id}", :role => "class_teacher"})
            redirect resource(:classrooms)
          end
        else
          unless teachers.include?("please")
            unless role.include?("")
              if @classroom.class_type == "Sports"
                @classroom.class_name = "Sports"
                if @classroom.valid?
                  @classroom.activate = true
                  @classroom.save
                  @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => "#{id}", :role => "Athletic Director"})
                  s = teachers.zip(role)
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
                @classroom.save
                @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => "#{id}", :role => "class_teacher"})
                s = teachers.zip(role)
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
    @classroom = @current_school.classrooms.find(params[:id])
    @teachers = @current_school.staff.find(:all)
    @class_peoples = @classroom.class_peoples
    render
  end

  def update
    @classroom = @current_school.classrooms.find(params[:id])
    @class = @current_school.classrooms.find(params[:id])
    @announcements = @current_school.announcements.find(:all, :conditions => ['access_name = ?', @class.class_name] )
    @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name = ?', @class.class_name])
    @forms = @current_school.forms.find(:all, :conditions => ['class_name = ?', @class.class_name])
    @calendars = @current_school.calendars.find(:all, :conditions => ['class_name = ?', @class.class_name])
    @teachers = @current_school.staff.find(:all)
    @class_peoples = @classroom.class_peoples
    ids = params[:class][:people][:ids]
    roles = params[:class][:people][:roles]
    @cla = @classroom.class_peoples.find(:first, :conditions => ['role=?', "class_teacher"] )
    @a_d = @classroom.class_peoples.find(:first, :conditions => ['role=?', "Athletic Director"] )
    cls_id = params[:class][:people][:teacher]
    if @classroom.update_attributes(params[:classroom])
      if @classroom.class_type == "Classes"
        @classroom.class_name = params[:classroom][:class_name].titleize
        @classroom.save
      end
      @announcements.each do |f|
        f.access_name = params[:classroom][:class_name]
        f.save!
      end
      @welcome_messages.each do |f|
        f.access_name = params[:classroom][:class_name]
        f.save!
      end
      @calendars.each do |f|
        f.class_name = params[:classroom][:class_name]
        f.save!
      end
      @forms.each do |f|
        f.class_name = params[:classroom][:class_name]
        f.save!
      end
      if (params[:class][:people][:teacher] == "")
        flash[:error] = "Please select Faculty from the list"
        render :edit
      elsif roles.nil?
        if @classroom.class_type == "Sports"
          ClassPeople.update(@a_d.id, {:person_id => "#{cls_id}", :classroom_id => @classroom.id, :role => "Athletic Director" } )
          redirect resource(:classrooms)
        else
          ClassPeople.update(@cla.id, {:person_id => "#{cls_id}", :classroom_id => @classroom.id, :role => "class_teacher" } )
          redirect resource(:classrooms)
        end
      else
        unless ( ids.include?("please") )|| ( ids.include?("") )
          unless roles.include?("")
            if @classroom.class_type == "Sports"
              ClassPeople.update(@a_d.id, { :person_id => "#{cls_id}", :classroom_id => @classroom.id, :role => "Athletic Director" })
              @class = @class_peoples.delete_if{|x| x.team_id != nil}
              @class_sp = @class.delete_if{|x| x.role == "Athletic Director"}
              @class_people_ids = @class_sp.collect{|x| x.id}
              s = ids.zip(roles,@class_people_ids)
              s.each do |f|
                if f[2].nil?
                  @classroom.class_peoples << ClassPeople.create({:person_id => f[0], :classroom_id => @classroom.id, :role => f[1] })
                else
                  @classroom.class_peoples << ClassPeople.update(f[2], { :person_id => f[0], :classroom_id => @classroom.id, :role => f[1] })
                end
              end
              redirect resource(:classrooms)
            else
              ClassPeople.update(@cla.id, { :person_id => "#{cls_id}", :classroom_id => @classroom.id, :role => "class_teacher" })
              @class = @class_peoples.delete_if{|x| x.team_id != nil}
              @class_p = @class.delete_if{|x| x.role == "class_teacher"}
              @class_people_ids = @class_p.collect{|x| x.id}
              s = ids.zip(roles,@class_people_ids)
              s.each do |f|
                if f[2].nil?
                  @classroom.class_peoples << ClassPeople.create({:person_id => f[0], :classroom_id => @classroom.id, :role => f[1] })
                else
                  @classroom.class_peoples << ClassPeople.update(f[2], { :person_id => f[0], :classroom_id => @classroom.id, :role => f[1] })
                end
              end
              redirect resource(:classrooms)
            end
          else
            flash[:error] = "Please enter the Role"
            render :edit
          end
        else
          flash[:error] = "Please select Faculty from the list"
          render :edit
        end
      end
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
      if params[:label] == "deactivate"
        @classroom = Classroom.find(params[:id])
        @classroom.class_name = @classroom.class_name.titleize
        @classroom.activate = false
        @classroom.save
        redirect resource(:classrooms)
      else
        @classroom = Classroom.find(params[:id])
        @classroom.class_name = @classroom.class_name.titleize
        @classroom.activate = true
        @classroom.save
        redirect resource(:classrooms)
      end
    end
  end

  def class_details
    @date = Date.today
    @selected = params[:label] #if params[:label] != nil
    @select = "classrooms"
    @classroom = @current_school.classrooms.find(params[:id])
    if @classroom.activate == true
      @calendars = @current_school.calendars.paginate(:all, :conditions => ['class_name = ?', @classroom.class_name.titleize], :per_page => 10, :page => params[:page], :order => 'start_date')
      @home_works = @classroom.home_works.paginate(:all, :conditions => ['school_id = ?', @current_school.id], :order => "due_date DESC", :per_page => 10, :page => params[:page])
      @announcements = @current_school.announcements.paginate(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", @classroom.class_name.titleize, true, true], :per_page => 10,
      :page => params[:page])
      @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name = ?', @classroom.class_name.titleize])
      @external_links = @current_school.external_links.find(:all, :conditions => ['label = ?', "Classrooms"])
      @spot_lights = @current_school.spot_lights.paginate(:all, :conditions => ['class_name = ?', @classroom.class_name], :per_page => 2, :page => params[:page], :order => 'created_at DESC')
      @ann = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", @classroom.class_name.titleize, true, true], :limit => 3)
      @sp_light = @current_school.spot_lights.find(:first, :conditions => ['class_name = ?', @classroom.class_name], :order => "created_at DESC" )
      render :layout => 'class_change', :id => @classroom.id
    else
      raise NotFound
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
    type2 = a.insert(1, "Sports")
    @class_types = a.insert(2, "Extra Cirrcular")
  end



end
