class Classrooms < Application
   
   layout 'default'
   before :access_rights, :exclude => [:class_details]
  
  
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
      if @classroom.class_type == "Sports"
         @classroom.class_name = "Sports"
      end
       if @classroom.save
           if role.nil?
	             ClassPeople.create({:classroom_id => @classroom.id, :person_id => "#{id}", :role => "class_teacher"})
           else
	             role_id = id.delete_at(0)
               if @classroom.class_type == "Sports"
                  @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => role_id, :role => "Athletic Director"})
               else 
                  @class_peoples << ClassPeople.create({:classroom_id => @classroom.id, :person_id => role_id, :role => "class_teacher"})
               end
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
      @class_sport = @class.delete_if{|x| x.role == "Athletic Director"}
      @teachers = Staff.find(:all)
      render                          
   end
   
   def update
      @teachers = Staff.find(:all)
      @classroom = Classroom.find(params[:id])
      @class_people = @classroom.class_peoples
      @class = @class_people.delete_if{|x| x.team_id != nil}
      @class_p = @class.delete_if{|x| x.role == "class_teacher"}
      @class_sport = @class.delete_if{|x| x.role == "Athletic Director"}
      id = params[:class][:people][:ids]
      role = params[:class][:people][:role] 
      
    if @classroom.update_attributes(params[:classroom])
       if @classroom.class_type == "Sports"
          @classroom.class_name = "Sports"
          @classroom.save
       end
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
    
   def class_details
      @classroom = Classroom.find(params[:id])
      @calendars = Calendar.find(:all, :conditions => ['class_name = ?', @classroom.class_name])
      @home_works = @classroom.home_works.find(:all)
      @announcements = Announcement.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", @classroom.class_name, true, true])
      @welcome_messages = WelcomeMessage.find(:all, :conditions => ['access_name = ?', @classroom.class_name])
      render :layout => 'class_change', :id => @classroom.id
   end
   
   private
   
    def access_rights
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
  
  
end
