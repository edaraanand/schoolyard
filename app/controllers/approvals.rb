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
                email_alerts(0, self.class, @announcement, @current_school)
              end
           else
              @class = @current_school.classrooms.find_by_class_name(@announcement.access_name)
              run_later do
                email_alerts(@class.id, self.class, @announcement, @current_school)
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
     @exist = "Student details entered by the parent match the school records"
     @not_exist = "Student details entered by the parent do not match the school records"
     @parent = @current_school.parents.find_by_id(params[:id])
     raise NotFound unless @parent
     @classrooms = @current_school.active_classrooms
     @registrations = @current_school.registrations.find(:all, :conditions => ['parent_id = ?', @parent.id])
     if params[:label] 
        if params[:label] != ""
           @room = @current_school.classrooms.find_by_class_name(params[:label])
           @students = @current_school.students.find(:all, :joins => :studies, :conditions => ['studies.classroom_id = ?', @room.id] )
        else
            @students = @current_school.students.find(:all, :conditions => ['activate = ?', true])
        end
    else
        @parent = @current_school.parents.find(params[:id])
        @students = @current_school.students.find(:all, :conditions => ['activate = ?', true])
    end
    render
  end

  def parent_grant
    @parent = @current_school.parents.find_by_id(params[:id])
    raise NotFound unless @parent
    @registrations = @current_school.registrations.find(:all, :conditions => ['parent_id = ?', @parent.id])
    if params[:approvetype] == "Approve & Grant Access"
       if (params[:class_not_found] == [""]) || (params[:student_not_found] == [""])
          flash[:error] = "Please select the student and classroom"
          redirect url(:approval_review, :id => @parent)
       else
           unless params[:student_not_found].nil?
             params[:student_not_found].each do |f|
               params[:class_not_found].each do |c|
                  @st = f.split
                  @student = @current_school.students.find(:first, :conditions => [" first_name in (?) AND last_name in (?)", @st, @st ] )
                  @class = @current_school.classrooms.find_by_class_name("#{c}")
                  @study_id = Study.find(:first, :conditions => ["classroom_id = ?", @class.id] )
                  Guardian.create({:student_id => @student.id, :parent_id => @parent.id })
                  Study.update(@study_id.id, {:student_id => @student.id, :classroom_id => @class.id})
               end
             end
           end
           unless params[:student_found].nil?
             @registrations.each do |f|
               @stud = @current_school.students.find(:first, :conditions => ["first_name = ? and last_name = ?", "#{f.first_name}", "#{f.last_name}" ])
               Guardian.create({:student_id => @stud.id, :parent_id => @parent.id })
             end
           end
           @parent.approved = 1
           @parent.activate = true
           @parent.save
           @parent.send_password_approve
           redirect url(:parent_approvals)
       end
    elsif params[:approvetype] == "Reject"
        @parent.approved = 3
        @parent.activate = false
        @parent.save!
        redirect url(:parent_approvals)
    else
      if params[:approvetype] == "activate"
         @registrations.each do |f|
            @stud = @current_school.students.find(:first, :conditions => ["first_name = ? and last_name = ?", "#{f.first_name}", "#{f.last_name}" ])
            @guardian =  Guardian.find(:first, :conditions => ["student_id = ? and parent_id = ?", @stud.id, @parent.id])
            if @guardian.nil?
               Guardian.create({:student_id => @stud.id, :parent_id => @parent.id })
            end
         end
         @parent.approved = 1
         @parent.activate = true
         @parent.send_password_approve
         @parent.save
      else
         @parent.approved = 4
         @parent.activate = false
         @parent.crypted_password = ""
         @parent.password_reset_key = ""
         @parent.save!
      end
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
