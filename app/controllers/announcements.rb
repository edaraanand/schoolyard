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
    if params[:label] == "classes"
       @classroom = @current_school.classrooms.find_by_id(params[:id])
       @announcements = @current_school.announcements.paginate(:all,
                                 :conditions => ["access_name = ? and label = ?", @classroom.class_name, 'staff' ],
                                 :order => "created_at DESC",
                                 :per_page => 10,
                                 :page => params[:page])
       @test = params[:id]
    elsif params[:label] == "Home Page"
       @announcements = @current_school.announcements.paginate(:all,
                                 :conditions => ["access_name = ? and label = ?", "Home Page", 'staff' ],
                                 :order => "created_at DESC",
                                 :per_page => 10,
                                 :page => params[:page])
       @test = "Home Page"
    else
       @announcements = @current_school.announcements.paginate(:all,
                                 :conditions => ['label = ?', 'staff'],
                                 :order => "created_at DESC",
                                 :per_page => 10,
                                 :page => params[:page])
       @test =  "All Announcements"
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
          type = "Announcement"
          Attachment.file(params.merge(:school_id => @current_school.id), type, @announcement.id)
       end 
       if @announcement.access_name == "Home Page"
          run_later do
             email_alerts(0, self.class, @announcement, @current_school)
          end
       else
         @class = @current_school.classrooms.find_by_class_name(@announcement.access_name)
         run_later do
           email_alerts(@class.id, self.class, @announcement, @current_school)
         end
       end
       redirect resource(:announcements)
    else
        @c = params[:announcement][:access_name]
        render :new
    end
  end
   
  def edit
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    @attachments = Attachment.announcements(@announcement.id, @current_school.id)
    @allowed = 1 - @attachments.size
    render
  end
  
  def update
     @announcement = @current_school.announcements.find_by_id(params[:id])
     raise NotFound unless @announcement
     @attachments = Attachment.announcements(@announcement.id, @current_school.id)
     @allowed = 1 - @attachments.size
     i=0
     if @announcement.update_attributes(params[:announcement])
        @announcement.person_id = session.user.id
        @announcement.approved = false
        @announcement.approve_announcement = true
        @announcement.label = 'staff'
        @announcement.school_id = @current_school.id
        @announcement.save
        if params[:attachment]
          unless params[:attachment]['file_'+i.to_s].empty?
             type = "Announcement"
             Attachment.file(params.merge(:school_id => @current_school.id), type, @announcement.id)
          end
        end
        redirect resource(:announcements)
     else
       render :edit
     end
  end

  def show
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    render
  end

  def delete
    if params[:label] == "attachment"
      @attachment = @current_school.attachments.find(params[:id])
      @announcement = @current_school.announcements.find_by_id(@attachment.attachable_id)
      @attachment.destroy
      @attachments = Attachment.announcements(@announcement.id, @current_school.id)
      @allowed = 1 - @attachments.size
      render :edit, :id => @announcement.id
    else
      @announcement = @current_school.announcements.find_by_id(params[:id])
      raise NotFound unless @announcement
      @page = @announcement.access_name
      Attachment.delete_all(['attachable_id = ?', @announcement.id])
      if @page == "Home Page"
         @announcement.destroy
         redirect resource(:homes)
      else
        @announcement.destroy
        @classroom = @current_school.classrooms.find(:first, :conditions => ['class_name = ?', @page ])
        redirect url(:class_details, :id => @classroom.id)
      end
    end
  end

  def preview
    @date = Date.today
    if params[:announcement][:access_name] == "Home Page"
       @select = "home"
       render :layout => 'home'
    else
       @selected = "announcements"
       @select =  "classrooms"
       @classroom = @current_school.classrooms.find(:first, :conditions => ['class_name = ?', params[:announcement][:access_name] ])
       render :layout => 'class_change', :id => @classroom.id
    end
  end
 

  private


  def classrooms
    @classes = @current_school.active_classrooms
  end

  def rooms
    @class = @current_school.active_classrooms
    room = @class.collect{|x| x.class_name }
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
