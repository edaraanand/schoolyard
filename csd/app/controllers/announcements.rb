class Announcements < Application
  
  def index
   @announcements = Announcement.find(:all, :order => 'expiration')
    render
  end
  
  def new
    @announcement = Announcement.new
    render
  end
  
  def create
    if params[:preview]
      render :preview
    else
      @announcement = Announcement.new(params[:announcement])
      @announcement.save
      redirect url(:announcements)
    end
  end
  
  def edit
    @announcement = Announcement.find(params[:id])
    render
  end
  
  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update_attributes(params[:announcement])
      redirect url(:announcements)
    else
      render :action => 'edit'
    end
  end
  
  def delete
    Announcement.find(params[:id]).destroy
    redirect url(:announcements)
  end
  
  def preview
     render
  end
  
         
end
