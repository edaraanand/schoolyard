class Teams < Application

  layout 'default'
  before :find_school
  before :access_rights, :exclude => [:sports]
  before :team_values, :exclude => [:index, :sports]

  def index
    @teams = @current_school.teams.find(:all)
    render
  end

  def new
    @team = Team.new
    render
  end

  def create
    @team = @current_school.teams.new(params[:team])
    id = params[:classroom][:people][:ids]
    role = params[:classroom][:people][:role]
    teachers = params[:classroom][:people][:teacher]
    classroom = @current_school.classrooms.find(:first, :conditions => ['class_name=?', params[:team][:classroom_id] ])
    @class_people = []
    if @team.valid?
      unless id.include?("please")
        if role.nil?
          @team.classroom_id = classroom.id
          @team.save
          @class_people << ClassPeople.create({:person_id => "#{id}", :classroom_id => classroom.id, :team_id => @team.id, :role => "coach" })
          redirect resource(:teams)
        else
          unless teachers.include?("please")
            unless role.include?("")
              @team.classroom_id = classroom.id
              @team.save
              @class_people << ClassPeople.create({:person_id => "#{id}", :team_id => @team.id, :classroom_id => classroom.id, :role => "coach"})
              s = teachers.zip(role)
              s.each do |r|
                @class_people << ClassPeople.create({:person_id => r[0], :classroom_id => classroom.id, :team_id => @team.id, :role => r[1] })
              end
              redirect resource(:teams)
            else
              flash[:error2] = "Please enter the Role"
              @classroom_id = params[:team][:classroom_id]
              render :new
            end
          else
            flash[:error]= "Please Select Faculty from the list"
            @classroom_id = params[:team][:classroom_id]
            render :new
          end
        end
      else
        flash[:error]= "Please Select Faculty from the list"
        @classroom_id = params[:team][:classroom_id]
        render :new
      end
    else
      @classroom_id = params[:team][:classroom_id]
      render :new
    end
  end

  def edit
    @team = @current_school.teams.find(params[:id])
    @class = @current_school.classrooms.find_by_id(@team.classroom_id)
    @team_peoples = @team.class_peoples
    render
  end

  def update
    @team = @current_school.teams.find(params[:id])
    @class = @current_school.classrooms.find_by_id(@team.classroom_id)
    @team_peoples = @team.class_peoples
    classroom = @current_school.classrooms.find(:first, :conditions => ['class_name=?', params[:team][:classroom_id] ])
    ids = params[:classroom][:people][:ids]
    roles = params[:classroom][:people][:roles]
    @coach_id = params[:classroom][:people][:coach]
    @team_role = @team.class_peoples.find(:first, :conditions => ['role=?', "coach"])
    if @team.update_attributes(params[:team])
      @team.classroom_id = classroom.id
      @team.save
      if (params[:classroom][:people][:coach] == "")
        flash[:error] = "Please select Faculty from the list"
        render :edit
      elsif roles.nil?
        ClassPeople.update(@team_role.id, {:classroom_id => classroom.id, :person_id => "#{@coach_id}", :role => "coach", :team_id => @team.id })
        redirect resource(:teams)
      else
        unless ( ids.include?("please") )|| ( ids.include?("") )
          unless roles.include?("")
            ClassPeople.update(@team_role.id, {:classroom_id => classroom.id, :person_id => "#{@coach_id}", :role => "coach", :team_id => @team.id })
            @team_p = @team_peoples.delete_if{|x| x.role == "coach"}
            @team_people_ids = @team_p.collect{|x| x.id}
            s = ids.zip(roles,@team_people_ids)
            s.each do |f|
              if f[2].nil?
                @team.class_peoples << ClassPeople.create({:person_id => f[0], :classroom_id => classroom.id, :role => f[1], :team_id => @team.id })
              else
                @team.class_peoples << ClassPeople.update(f[2],{ :person_id => f[0], :classroom_id => classroom.id, :role => f[1], :team_id => @team.id })
              end
            end
            redirect resource(:teams)
          else
            flash[:error2] = "Please enter a Role"
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
      @team_p = ClassPeople.find(params[:id])
      @team = @current_school.teams.find_by_id(@team_p.team_id)
      @class = @current_school.classrooms.find_by_id(@team.classroom_id)
      @team_peoples = @team.class_peoples
      @team_p.destroy
      render :edit, :id => @team.id
    else
      @current_school.teams.find(params[:id]).destroy
      redirect resource(:teams)
    end
  end

  def sports
    @select = "sports"
    @selected = params[:label]
    @teams = @current_school.teams.paginate(:all, :per_page => 20,
    :page => params[:page])
    @calendars = @current_school.calendars.find(:all, :conditions => ['class_name = ?', "Sports"], :order => 'start_date')
    @announcements = @current_school.announcements.paginate(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", "Sports", true, true], :per_page => 2, :page => params[:page])
    @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ['access_name = ?', "Sports"])
    @ann = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", "Sports", true, true], :limit => 3)
    render :layout => 'sports'
  end


  private

  def team_values
    @teachers = @current_school.staff.find(:all)
    @classrooms = @current_school.active_classrooms
    @years = (2009..2025).to_a
  end

  def access_rights
    @selected = "teams"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('teams')
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
