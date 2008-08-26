class Calendars < Application
  
  def index
    @calendars = Calendar.find(:all)
    render
  end
  
  def new
    @calendar = Calendar.new
    render
  end
  
  def create
    @calendar = Calendar.new(params[:calendar])
    @calendar.save
    redirect url(:calendar)
  end
  
 
  
end
