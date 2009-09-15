class Approvals < Application
 
  layout 'default'
  before :find_school
  before :classrooms, :only => [:edit, :update]
  before :ensure_authenticated
  before :access_rights
  before :parent_registration, :only => [:parent_approvals, :approval_review, :parent_grant, :parent_reject]
 
 
  def index
    @selected = "approve"
    @announcements = @current_school.announcements.paginate(:all, :conditions => ["approve_announcement = ? and approved = ? and label != ?", true, false, "feedback" ], :per_page => 10,
    :page => params[:page], :order => "created_at DESC")
    render
  end
 
  def show
    @selected = "approve"
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    render :id => @announcement.id
  end
 
  def edit
    @selected = "approve"
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    render
  end
 
  def update
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    if @announcement.update_attributes(params[:announcement])
      @announcement.person_id = session.user.id
      @announcement.approved = false
      @announcement.approve_announcement = true
      @announcement.school_id = @current_school.id
      @announcement.label = 'parent'
      @announcement.save
      redirect resource(:approvals)
    else
      render :edit
    end
  end
 
  def publish
    @announcement = @current_school.announcements.find_by_id(params[:id])
    raise NotFound unless @announcement
    if params[:approvetype] == "Approve & Publish"
        if params[:announcement]
           @announcement.update_attributes(params[:announcement])
        end
        @announcement.approve_comments = params[:comments]
        @announcement.approved = @announcement.approve_announcement = true
        @announcement.approved_by = session.user.id
        @announcement.school_id = @current_school.id
        if @announcement.save
           if @announcement.access_name == "Home Page"
              run_later do
                email_alerts(0, Announcements, @announcement, @current_school)
              end
           else
              @class = @current_school.classrooms.find_by_class_name(@announcement.access_name)
              run_later do
                email_alerts(@class.id, Announcements, @announcement, @current_school)
              end
           end
          redirect resource(:approvals)
        else
           flash[:error] = "please check the Announcement details and its Expiration date"
           redirect url(:approval, @announcement.id)
        end
    else
        if params[:announcement]
          @announcement.update_attributes(params[:announcement])
        end
        @announcement.reject_comments = params[:comments]
        @announcement.approved = @announcement.approve_announcement = false
        @announcement.rejected_by = session.user.id
        @announcement.school_id = @current_school.id
        if @announcement.save
           redirect resource(:approvals)
        else
           flash[:error] = "please check the Announcement details and its Expiration date"
           redirect url(:approval, @announcement.id)
        end
     end
  end
 
  def preview
    @title = params[:announcement][:title]
    @content = params[:announcement][:content]
    render :layout => 'preview'
  end
 
  def parent_approvals
    if params[:label] == "approved"
       @parents = @current_school.parents.paginate(:all, :conditions => ['approved = ?', 1], :order => "created_at DESC", :per_page => 25,  :page => params[:page] )
       @test = "approved"
    elsif params[:label] == "rejected"
       @parents = @current_school.parents.paginate(:all, :conditions => ['approved = ?', 3 ], :order => "created_at DESC", :per_page => 25,  :page => params[:page] )
       @test = "rejected"
    elsif params[:label] == "pending"
       @parents = @current_school.parents.paginate(:all, :conditions => ['approved = ?', 2], :order => "created_at DESC", :per_page => 25,  :page => params[:page] )
       @test = "pending"
    else
       @parents = @current_school.parents.paginate(:all, :order => "created_at DESC", :per_page => 25,  :page => params[:page])
       @test = "registrations"
    end
    render
  end
 
  def approval_review
    @parent = @current_school.parents.find_by_id(params[:id])
    raise NotFound unless @parent
    @classrooms = @current_school.active_classrooms
    @registrations = @current_school.registrations.find(:all, :conditions => ['parent_id = ?', @parent.id])
    @students = @current_school.students.find(:all, :conditions => ['activate = ?', true] )
    render
  end
 
  def parent_grant
    @parent = @current_school.parents.find_by_id(params[:id])
    raise NotFound unless @parent
    @registrations = @current_school.registrations.find(:all, :conditions => ['parent_id = ?', @parent.id])
    if params[:approvetype] == "Approve & Grant Access"
       if params[:class_room]
          student_mapping
       end
       @parent.approved = 1  # (Approved = 1, Rejected = 3, Pending Approval = 2)
       @parent.activate = true
       @parent.save
       @parent.send_password_approve
       redirect url(:parent_approvals)
    else
       @parent.activate = false
       @parent.approved = 3  # (Approved = 1, Rejected = 3, Pending Approval = 2)
       @parent.save
       redirect url(:parent_approvals)
    end
  end
 
  def student_mapping
     @array = (1..20).to_a
     if params[:class_room]
        @array.each do |f|
           unless (params[:class_room][:room]["room_#{f}".intern].nil?  && params[:student_name][:name]["name_#{f}".intern].nil?)
             if (params[:class_room][:room]["room_#{f}".intern] != "" && params[:student_name][:name]["name_#{f}".intern] != "")
                student_id = params[:student_name][:name]["name_#{f}".intern]
                class_id = params[:class_room][:room]["room_#{f}".intern] 
                @study = Study.find_by_classroom_id_and_student_id(class_id, student_id)
                @guardian = Guardian.find_by_student_id_and_parent_id(student_id, @parent.id)
                Guardian.create({:student_id => student_id, :parent_id => @parent.id }) unless @guardian.nil?
                Study.update(@study.id, {:student_id => student_id, :classroom_id => class_id})
             end
           end
        end
     end
     if params[:classes]
       @array.each do |f|
         unless (params[:classes][:room]["room_#{f}".intern].nil? && params[:studs][:name]["name_#{f}".intern].nil? )
           if (params[:classes][:room]["room_#{f}".intern] != "" && params[:studs][:name]["name_#{f}".intern] != "")
              student_id = params[:studs][:name]["name_#{f}".intern]
              @classroom = @current_school.classrooms.find_by_class_name(params[:classes][:room]["room_#{f}".intern])
              @guardian = Guardian.find_by_student_id_and_parent_id(student_id, @parent.id)
              @study = Study.find_by_student_id(student_id)
              Guardian.update(@guardian.id, {:student_id => student_id, :parent_id => @parent.id})
              Study.update(@study.id, {:student_id => student_id, :classroom_id => @classroom.id})
           end
         end
       end
     end
  end
  
  def edit_approve
    @parent = @current_school.parents.find_by_id(params[:id])
    raise NotFound unless @parent
    @classrooms = @current_school.active_classrooms
    @guardians = Guardian.find(:all, :conditions => ['parent_id = ?', @parent.id])
    @registrations = @current_school.registrations.find(:all, :conditions => ['parent_id = ?', @parent.id])
    @students = @current_school.students.find(:all, :conditions => ['activate = ?', true] )
    render
  end
  
  def approved
     @parent = @current_school.parents.find_by_id(params[:id])
     raise NotFound unless @parent
     @classrooms = @current_school.active_classrooms
     @registrations = @current_school.registrations.find(:all, :conditions => ['parent_id = ?', @parent.id])
     @students = @current_school.students.find(:all, :conditions => ['activate = ?', true] )
     if params[:ref]
        @parent.activate = false
        @parent.approved = 3  # (Approved = 1, Rejected = 3, Pending Approval = 2)
        @parent.save
        redirect url(:edit_approve, :id => @parent.id)
     elsif params[:approve]
        @parent.activate = true
        @parent.approved = 1  # (Approved = 1, Rejected = 3, Pending Approval = 2)
        @parent.save
        redirect url(:edit_approve, :id => @parent.id)
     else
        student_mapping
        redirect url(:parent_approvals)
     end
  end
 
  private
 
  def access_rights
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('approve_announcement')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @access_people.each do |f|
      have_access = (f.all == true) || (f.access_id == @ann.id)
      break if have_access
    end
    unless have_access
      redirect resource(:homes)
    end
  end
 
  def parent_registration
    @selected = "parent_registration"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('parent_registration')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @access_people.each do |f|
      have_access = (f.all == true) || (f.access_id == @ann.id)
      break if have_access
    end
    unless have_access
      redirect resource(:homes)
    end
  end
 
  def classrooms
    @class = @current_school.active_classrooms
    room = @class.collect{|x| x.class_name }
    @classrooms = room.insert(0, "Home Page")
  end
 
 
end
