class Classrooms < Application
  
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
       people = params[:classroom].delete(:people)
       @classroom = Classroom.new(params[:classroom])
       people[:ids].each_with_index do |id , n|
	@classroom.class_peoples << ClassPeople.create(:person_id => people[:ids][n],
							:role => people[:role][n])
	end
	@classroom.save
      redirect url(:classrooms)
   end  
  
   def edit
      @classroom = Classroom.find(params[:id])
      @class_people = @classroom.class_peoples
      @teachers = Staff.find(:all)
      render                          
   end
   
   def update
      @classroom = Classroom.find(params[:id])
      @class_peoples = @classroom.class_peoples
         id = params[:classroom][:people][:ids]
	 role = params[:classroom][:people][:role]
	   s = id.zip(role)
	 @class_p = @class_peoples.collect{|x| x.id}
	 @classes = id.zip(role, @class_p)
	 @classes.each do |l|
	      if l[2].nil?
		  @classroom.class_peoples << ClassPeople.create!({:person_id => l[0], :role => l[1]})
	      else
		 @classroom.class_peoples << ClassPeople.update(l[2], {:person_id => l[0], :role => l[1] })
	      end
         end
	 classroom = params[:classroom].delete(:people)
	    @classroom.update_attributes(params[:classroom])
	 redirect url(:classrooms)
   end                                      
   
   def destroy
      Classroom.find(params[:id]).destroy
      redirect url(:classrooms) 
   end
  
end
