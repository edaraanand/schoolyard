class Calendars < Application

  def index
     @calendars = Calendar.find(:all, :order => 'start_date')
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
	@day_event = false
	render :new 
     end
  end

  def edit
     @calendar = Calendar.find(params[:id])
     @class_rooms = Classroom.find(:all) 
     @cal = Calendar.find(:first, :conditions => ['day_event=?', true])
     render
  end
  
  def update
     @class_rooms = Classroom.find(:all)
     @calendar = Calendar.find(params[:id])
     if @calendar.update_attributes(params[:calendar])
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
