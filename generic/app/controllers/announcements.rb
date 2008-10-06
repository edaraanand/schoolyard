class Announcements < Application

 
  def index
     @access_people = @current_user.access_peoples
     @accesses = Access.find(:all)
      @accesses.each do |f|
	have_access = false
        @access_people.each do |l|
	  have_access = l.all || (f.id == l.access_id) 
	  break if have_access	
	end
	if have_access
	   @access_rights =  @accesses.delete_if{|x| x.name == "view_all"}
	else
	   @access_rights = @current_user.accesses_without_all
	end
      end
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
