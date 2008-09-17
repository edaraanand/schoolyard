class Calendars < Application

   layout 'admin'
   before :access_rights

  def index
    @calendars = Calendar.find(:all, :order => 'start_time')
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

  private

  def access_rights
     unless current_user.event_access == true
        redirect url(:homes)
     end
  end
  
 end
