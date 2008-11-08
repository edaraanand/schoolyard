class Calendars < Application
 layout 'default'
 
  def index
     @calendars = Calendar.find(:all)
     render
  end
  
  def new
     @calendar = Calendar.new
     @class_rooms = Classroom.find(:all)
     render
  end
  
  def create
     @class_rooms = Classroom.find(:all)
     @calendar = Calendar.new(params[:calendar])
     if @calendar.save
	      redirect resource(:calendars)
     else
	      render :new 
     end
  end

  def edit
     @calendar = Calendar.find(params[:id])
     @class_rooms = Classroom.find(:all) 
     render
  end
  
  def update
     @class_rooms = Classroom.find(:all)
     @calendar = Calendar.find(params[:id])
     if @calendar.update_attributes(params[:calendar])
	     if @calendar.day_event == true
	        @calendar.start_time = nil
	        @calendar.end_time = nil
       end
	      @calendar.save
	      redirect resource(:calendars)
     else
	      render :edit
     end
  end
  
  def delete
      Calendar.find(params[:id]).destroy
      redirect resource(:calendars)
  end
  
end
