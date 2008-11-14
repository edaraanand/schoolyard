class Classrooms < Application
   layout 'default'
  
   def index
      @classrooms = Classroom.find(:all)
      render
   end
  
   def new
      @classroom = Classroom.new 
      @teachers = Staff.find(:all)
      render
   end
   
   def create 
      @classroom = Classroom.new(params[:classroom])
      @teachers = Staff.find(:all)
      id = params[:class][:people][:ids]
      role = params[:class][:people][:role]
      @class_peoples = []
     if @classroom.save
         if role.nil?
	    ClassPeople.create({:classroom_id => @classroom.id, :person_id => "#{id}", :role => "class_teacher"})
         else
	    role_id = id.delete_at(0)
	    @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => role_id, :role => "class_teacher"})
	    s = id.zip(role)
	    s.each do |f|
	       @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => f[0], :role => f[1] })
            end
          end
	  redirect resource(:classrooms)
     else
	 render :new
     end
      
   end  
  
   def edit
      @classroom = Classroom.find(params[:id])
      @class_people = @classroom.class_peoples
      @class = @class_people.delete_if{|x| x.team_id != nil}
      @class_p = @class.delete_if{|x| x.role == "class_teacher"}
      @teachers = Staff.find(:all)
      render                          
   end
   
   def update
       @teachers = Staff.find(:all)
       @classroom = Classroom.find(params[:id])
       @class_people = @classroom.class_peoples
       @class = @class_people.delete_if{|x| x.team_id != nil}
      @class_p = @class.delete_if{|x| x.role == "class_teacher"}
      id = params[:class][:people][:ids]
      role = params[:class][:people][:role] 
     # @classrooms = []
    #  @classrooms << @classroom.update_attributes(params[:classroom])
    if @classroom.update_attributes(params[:classroom])
       @class_peoples = @classroom.class_peoples
      @cla = @classroom.class_peoples.find(:first, :conditions => ['role=?', "class_teacher"] )
      @class = @class_peoples.delete_if{|x| x.team_id != nil}
      @class_p = @class.delete_if{|x| x.role == "class_teacher"}
      @class_teacher = @classroom.class_peoples.find(:first, :conditions => ['role=?', "class_teacher"] )
      @class_id = @class_p.collect{|x| x.id }
      if role.nil?
	 ClassPeople.update(@cla.id, {:person_id => "#{id}", :classroom_id => @classroom.id, :role => "class_teacher" } )
      else
	 ClassPeople.update(@cla.id, { :person_id => id[0], :classroom_id => @classroom.id, :role => "class_teacher" })    
	 role_id = id.delete_at(0)
	 s = id.zip(role,@class_id)
	 s.each do |f|
	    if f[2].nil?
	       @classroom.class_peoples << ClassPeople.create({:person_id => f[0], :classroom_id => @classroom.id, :role => f[1] })	 
            else
	       @classroom.class_peoples << ClassPeople.update(f[2], { :person_id => f[0], :classroom_id => @classroom.id, :role => f[1] })
            end
         end
      end
      redirect resource(:classrooms)
   else
	render :edit
   end
   
   end                                      
   
   def delete
      Classroom.find(params[:id]).destroy
      redirect resource(:classrooms) 
   end
  
  
end
