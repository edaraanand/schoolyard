class FromPrincipals < Application

  def index
     @announcements = Announcement.find(:all, :conditions => ['label=?', "from_principal"])
     render
  end
  
  def new
     @announcement = Announcement.new
     render
  end
  
  def create
     @announcement = Announcement.new(params[:announcement])
     @announcement.label = "from_principal"
     @announcement.save
     redirect url(:from_principals)
  end

  def edit
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def update
     @announcement = Announcement.find(params[:id])
     @announcement.update_attributes(params[:announcement])
     @announcement.label = "from_principal"
     @announcement.save
     redirect url(:from_principals)
  end
  
  def show
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def delete
     Announcement.find(params[:id]).destroy
     redirect url(from_principals)
  end
  
   def preview
      render :layout => 'preview'
   end
  
end
