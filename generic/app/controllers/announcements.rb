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
    if params[:announcement][:access_name] != ""
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
             :size => params[:attachment]['file_'+i.to_s][:size],
             :school_id => @current_school.id
             )
             File.makedirs("public/uploads/#{@attachment.id}")
             FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
          end
          redirect resource(:announcements)
       else
           @c = params[:announcement][:access_name]
           render :new
       end
    else
       flash[:error] = "Please select the option"
       @c = params[:announcement][:access_name]
       render :new
    end
    
  end
  
  def edit
    @announcement = @current_school.announcements.find(params[:id])
    @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
    @allowed = 1 - @attachments.size
    render
  end

  def show
    @announcement = @current_school.announcements.find(params[:id])
    render
  end

  def update
    @announcement = @current_school.announcements.find(params[:id])
    @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
    @allowed = 1 - @attachments.size
    i=0
    if params[:attachment]
      if params[:announcement][:access_name] != ""
        if @announcement.update_attributes(params[:announcement])
          unless params[:attachment]['file_'+i.to_s].empty?
            @attachment = Attachment.create( :attachable_type => "Announcement",
            :attachable_id => @announcement.id,
            :filename => params[:attachment]['file_'+i.to_s][:filename],
            :content_type => params[:attachment]['file_'+i.to_s][:content_type],
            :size => params[:attachment]['file_'+i.to_s][:size],
            :school_id => @current_school.id
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
        flash[:error] = "Please select the option"
        render :edit
      end
    else
      if params[:announcement][:access_name] != ""
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
      else
        flash[:error] = "Please select the option"
        render :edit
      end
    end
  end

  def delete
    if params[:label] == "attachment"
      @attachment = @current_school.attachments.find(params[:id])
      @announcement = @current_school.announcements.find_by_id(@attachment.attachable_id)
      @attachment.destroy
      @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
      @allowed = 1 - @attachments.size
      render :edit, :id => @announcement.id
    else
      @announcement = @current_school.announcements.find(params[:id])
      Attachment.delete_all(['attachable_id = ?', @announcement.id])
      @announcement.destroy
      redirect resource(:announcements)
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
    @classes = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
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
