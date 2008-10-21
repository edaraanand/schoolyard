class Calendars < Application

  def index
     @calendars = Calendar.find(:all, :order => 'start_date')
     puts @calendars.inspect
     render
  end
  
  def new
	  
     @calendar = Calendar.new
     @class_rooms = Classroom.find(:all)
     render
  end
  
  def create
     @calendar = Calendar.new(params[:calendar])
     if @calendar.save
        redirect url(:calendars)
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
     @calendar = Calendar.find(params[:id])
     if @calendar.update_attributes(params[:calendar])
        redirect url(:calendars)
     else
	render :edit
     end
  end
  
  def delete
      Calendar.find(params[:id]).destroy
      redirect url(:calendars)
  end
  
end
