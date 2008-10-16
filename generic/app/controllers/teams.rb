class Teams < Application

  def index
     @teams = Team.find(:all)
     render
  end
  
  def new
     @team = Team.new 
     @teachers = Staff.find(:all)
     @classrooms = Classroom.find(:all)
     @years = (1999..2020).to_a
     render
  end
  
  def create
     classroom = Classroom.find(:first, :conditions => ['class_name=?', params[:team][:classroom_id] ])
     @team = Team.create(params[:team])
     id = params[:classroom][:people][:ids]
     role = params[:classroom][:people][:role]
     @class_people = []
     if role.nil?
	@class_people << ClassPeople.create({:person_id => "#{id}", :classroom_id => classroom.id, :team_id => @team.id, :role => "coach" })
     else
	role_id = id.delete_at(0)
	@class_people << ClassPeople.create({:person_id => role_id, :team_id => @team.id, :classroom_id => classroom.id, :role => "coach"})
        s = id.zip(role)
     	s.each do |r|
	   @class_people << ClassPeople.create({:person_id => r[0], :classroom_id => classroom.id, :team_id => @team.id, :role => r[1] })
        end
     end
     redirect url(:teams)
  end

  def edit     
     @team = Team.find(params[:id])
     @teachers = Staff.find(:all)
     @classrooms = Classroom.find(:all)
     @years = (1999..2020).to_a
     team_peoples = @team.class_peoples
     @team_peoples = team_peoples.delete_if{|x| x.role == "coach" }
     render
  end
  
  def update
     @team = Team.find(params[:id])
     classroom = Classroom.find(:first, :conditions => ['class_name=?', params[:team][:classroom_id] ])
     id = params[:classroom][:people][:ids]
     role = params[:classroom][:people][:role]
     @team_p =  Team.update(@team.id, {:classroom_id => classroom.id, :year => params[:team][:year], :team_name => params[:team][:team_name]})
     @class_teams = @team.class_peoples
     @cls_ts = @team.class_peoples.find(:first, :conditions => ['role=?', "coach"])
     @team.class_peoples << ClassPeople.update(@cls_ts.id, {:person_id => id[0], :role => "coach", :team_id => @team.id })
     @cla_tea = @class_teams.delete_if{|x| x.role == "coach"}
     @team_people = @cla_tea.collect{|x| x.id }
     if role.nil?
        @class_t = ClassPeople.find(:first, :conditions => ['team_id=?', @team.id] )
	ClassPeople.update(@class_t.id, {:classroom_id => classroom.id, :person_id => "#{id}", :role => "coach", :team_id => @team.id })
     else
	role_id = id.delete_at(0)
	@c = ClassPeople.find(:first, :conditions => ['person_id=?', role_id])
	s = id.zip(role, @team_people)
	s.each do |f|
	  if f[2].nil?
	     @team.class_peoples << ClassPeople.create({:person_id => f[0], :classroom_id => classroom.id, :role => f[1], :team_id => @team.id })
	  else
	     @team.class_peoples << ClassPeople.update(f[2],{ :person_id => f[0], :classroom_id => classroom.id, :role => f[1], :team_id => @team.id })
	  end
	end
     end
     redirect url(:teams)
  end
  

end
