class Announcements < Application

 
  def index
     classrooms
     puts params[:access_name].inspect
     @announcements = Announcement.find(:all, :conditions => ['access_name=?', params[:access_name] ])
     if params[:access_name].nil?
	@announce = Announcement.find(:all)
     end
     render
  end
  
  def new
     @announcement = Announcement.new
     classrooms
     render 
  end
  
  def create
     @announcement = Announcement.new(params[:announcement])
     @announcement.person_id = @current_user.id
    # @announcement.file_file_name = params[:announcement][:file][:filename]
    # @announcement.file_content_type = params[:announcement][:file][:content_type]
     #@announcement.file_file_size = params[:announcement][:file][:size]
     classrooms
     #raise "Eshwar".inspect
     if @announcement.save
	redirect resource(:announcements)
     else
	render :new
     end
  end       
  
  def edit
     classrooms
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def update 
     @announcement = Announcement.find(params[:id])
     classrooms
     if @announcement.update_attributes(params[:announcement])
	@announcement.person_id = @current_user.id
	@announcement.save
	redirect resource(:announcements)
     else
	render :edit
     end
  end
  
  def delete
      Announcement.find(params[:id]).destroy
      redirect resource(:announcements)
   end
   
   def preview
      @title = params[:announcement][:title]
      @content = params[:announcement][:content]
      render :layout => 'preview'
   end
  
   private
   
   def access_rights
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
  end
  
  def classrooms
     @class = Classroom.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "HomePage")
  end
  
end
