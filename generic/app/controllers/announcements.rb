class Announcements < Application

 
  def index
     @access_rights = @current_user.accesses_without_all 
     @announcements = Announcement.find(:all, :conditions => ['access_name=?', params[:access_name] ])
     render
  end
  
  def new
     @announcement = Announcement.new
     @access_rights = @current_user.accesses_without_all
     render
  end
  
  def create
     @announcement = Announcement.new(params[:announcement])
     @announcement.person_id = @current_user.id
     @announcement.save
     redirect url(:announcements)
  end       
  
  def edit
     @access_rights = @current_user.accesses_without_all
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def update 
     @announcement = Announcement.find(params[:id])
     if @announcement.update_attributes(params[:announcement])
	@announcement.person_id = @current_user.id
	@announcement.save
	redirect url(:announcements)
     else
	render :edit
     end
                                  
  end
  
   def delete
      Announcement.find(params[:id]).destroy
      redirect url(:announcements)
   end
   
   def preview
      render :layout => 'preview'
   end
  
end
