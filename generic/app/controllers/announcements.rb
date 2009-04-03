class Announcements < Application
   layout 'default'
   before :find_school
   before :classrooms
   before :rooms, :only => [:new, :edit, :delete]
   before :access_rights, :exclude => [:parent_approval, :approve_process]
   before :approval_right, :only => [:parent_approval, :approve_process ]
   
  def index
    @message1 = "Approved"
    @message2 = "Pending"
    @message3 = "Rejected"
    @announcements = @current_school.announcements.paginate(:all, :conditions => ["access_name = ? and label = ?", params[:access_name], 'staff' ], :order => "created_at DESC", :per_page => 4, :page => params[:page])
     if params[:access_name].nil?
       @announce = @current_school.announcements.paginate(:all, :conditions => ['label = ?', 'staff'], :order => "created_at DESC", :per_page => 4, :page => params[:page])
     end
     if params[:access_name] == "All Announcements"
       @all_announcements = @current_school.announcements.paginate(:all, :conditions => ['label = ?', 'staff'], :order => "created_at DESC", :per_page => 4, :page => params[:page])
     end
     render
  end 
  
  def new
     @announcement = Announcement.new
     render 
  end
  
  def create
    @announcement = session.user.announcements.build(params[:announcement])
    i=0
    if @announcement.valid?
       @announcement.approved = false
       @announcement.approve_announcement = true
       @announcement.label = 'staff'
       @announcement.school_id = @current_school.id
       @announcement.save
       unless params[:attachment]['file_'+i.to_s].empty?
           @attachment = Attachment.create( :attachable_type => "Announcement",
                                        :attachable_id => @announcement.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
            )
           File.makedirs("public/uploads/#{@attachment.id}")
           FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
        end
	      redirect resource(:announcements)
     else
	      render :new
     end
  end       
  
  def edit
     @announcement = Announcement.find(params[:id])
     @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
     @allowed = 1 - @attachments.size
     render
  end
  
  def show
    @announcement = Announcement.find(params[:id])
    render
  end
  
  def update 
     @announcement = @current_school.announcements.find(params[:id])
     @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
     @allowed = 1 - @attachments.size
     i=0
     if params[:attachment]
        if @announcement.update_attributes(params[:announcement])
           unless params[:attachment]['file_'+i.to_s].empty?
                @attachment = Attachment.create( :attachable_type => "Announcement",
                                        :attachable_id => @announcement.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
                 )
                  File.makedirs("public/uploads/#{@attachment.id}")
                  FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
           end
           @announcement.person_id = session.user.id
           @announcement.approved = false
           @announcement.approve_announcement = true
           @announcement.label = 'staff'
           @announcement.school_id = @current_school.id
      	   @announcement.save          
	         redirect resource(:announcements)
        else
	         render :edit
        end
    else
         if @announcement.update_attributes(params[:announcement])
            @announcement.person_id = session.user.id
            @announcement.approved = false
            @announcement.approve_announcement = true
            @announcement.label = 'staff'
            @announcement.school_id = @current_school.id
      	    @announcement.save          
	          redirect resource(:announcements)
         else
	          render :edit
         end
    end   
  end
  
  def delete
     if params[:label] == "attachment"
        @attachment = Attachment.find(params[:id])
        @announcement = Announcement.find_by_id(@attachment.attachable_id)
        @attachment.destroy
        @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
        @allowed = 1 - @attachments.size
        render :edit, :id => @announcement.id
     else
        @announcement = Announcement.find(params[:id])
        Attachment.delete_all(['attachable_id = ?', @announcement.id])
        @announcement.destroy
        redirect resource(:announcements)
     end
  end
   
   def preview
      @title = params[:announcement][:title]
      @content = params[:announcement][:content]
      render :layout => 'preview'
   end
   
       
   private
  
  
  def classrooms
     @class = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
     room = @class.collect{|x| x.class_name.titleize }
     @classrooms = room.insert(0, "All Announcements")
     @classrooms = room.insert(1, "Home Page")
  end
  
  def rooms
      @class = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
      room = @class.collect{|x| x.class_name.titleize }
      @classrooms = room.insert(0, "Home Page")
  end
  
  def access_rights
     @selected = "announcements"
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('announcements')
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
