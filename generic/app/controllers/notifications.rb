class Notifications < Application
   
   layout 'default'
   before :find_school
   before :access_rights
   
  def index
     @announcements = @current_school.announcements.paginate(:all,
                                                             :conditions => ['label=?', "urgent"],
                                                             :order => "created_at DESC",
                                                             :per_page => 10,
                                                             :page => params[:page] )
     render
  end
  
  def new
    @announcement = Announcement.new
    render
  end
  
  def create
     @announcement = @current_school.announcements.new(params[:announcement])    
     if @announcement.valid?
        @announcement.label = "urgent"
        @announcement.save
        twitter = Twitter.new(@current_school.username, @current_school.password)
        twitter.post(params[:announcement][:content]) 
        redirect url(:notifications)
     else
        render :new
     end
  end
  
 # def edit
 #   @announcement = @current_school.announcement.find(params[:id])
 #   render
 # end
 # 
 # def update
 #   @announcement = @current_school.announcement.find(params[:id])
 #    if @announcement.update_attributes(params[:announcement])
 #       @announcement.label = "urgent "
 #       @announcement.save
 #       redirect resource(:notifications)
 #    else
 #       render :edit
 #    end
 #   render
 # end
 
 
  def delete
     @announcement = @current_school.announcements.find(params[:id])
     @announcement.destroy
     redirect resource(:notifications)
  end
  
  
  private

  def access_rights
     @selected = "urgent_announcement"
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('urgent_announcement')
     @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
     @access_people.each do |f|
       have_access = (f.all == true) || (f.access_id == @ann.id)
       break if have_access
     end
     unless have_access
       redirect resource(:homes)
     end
  end
  
  
end                                                                         
