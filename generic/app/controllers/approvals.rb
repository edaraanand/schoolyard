class Approvals < Application
  
  layout 'default'
  before :classrooms, :only => [:edit, :update]
  before :ensure_authenticated
  before :access_rights
  before :parent_registration, :only => [:parent_approvals, :approval_review, :parent_grant, :parent_reject]
  
  def index
     @announcements = Announcement.find(:all, :conditions => ["approve_announcement = ? and approved = ?", true, false ])
     #@announcements = Announcement.find(:all, :conditions => ['label=?', 'parent'])
     render
  end
  
  def show
     @announcement = Announcement.find(params[:id])
     render :id => @announcement.id
  end
  
  def edit
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def update
     @announcement = Announcement.find(params[:id])
     if @announcement.update_attributes(params[:announcement])
        @announcement.person_id = session.user.id
        @announcement.approved = false
        @announcement.approve_announcement = true
        @announcement.label = 'parent'
        redirect resource(:approvals)
      else
        render :edit
      end
  end
  
  def publish
     @announcement = Announcement.find(params[:id])
     if params[:approvetype] == "Approve & Publish"
        @announcement.comments = params[:announcement][:comments]
        @announcement.approved = @announcement.approve_announcement = true
        @announcement.save 
        redirect resource(:approvals)
      else
        @announcement.approved = @announcement.approve_announcement = false
        @announcement.save 
        redirect resource(:approvals)
      end
  end
  
  def preview
     @title = params[:announcement][:title]
     @content = params[:announcement][:content]
     render :layout => 'preview'
  end
  
  def parent_approvals
     if params[:approve_status] == "Approved"
        @approved_parents = Parent.find(:all, :conditions => ['approved = ?', 1] )
     end
     if params[:approve_status] == "PendingApproval"
        @pending_parents = Parent.find(:all, :conditions => ['approved = ?', 2] )
     end
     if params[:approve_status] == "Rejected"
       @reject_parents = Parent.find(:all, :conditions => ['approved = ?', 3 ] )
     end
     if params[:approve_status].nil?
        @parents = Parent.find(:all, :conditions => ['approved = ?', 2] )
     end
     render
  end
  
  def approval_review
     @parent = Parent.find(params[:id])
     @students = Student.find(:all)
     @classrooms = Classroom.find(:all)
     @registrations = Registration.find(:all, :conditions => ['parent_id = ?', @parent.id])
     @exist = "Following Student was found"
     @not_exist = "Following Student was not found"
     render
  end
  
  def parent_grant
     @parent = Parent.find(params[:id])
     @registrations = Registration.find(:all, :conditions => ['parent_id = ?', @parent.id])
     if params[:approvetype] == "Approve & Grant Access"
          if (params[:class_not_found] == [""]) || (params[:student_not_found] == [""])
             flash[:error] = "Please select the student and classroom"
             redirect url(:approval_review, :id => @parent)
          else
             params[:student_not_found].each do |f|
                 params[:class_not_found].each do |c|
                     @st = f.split
                     @student = Student.find(:first, :conditions => [" first_name in (?) AND last_name in (?)", @st, @st ] )
                     puts @student.inspect
                     @class = Classroom.find_by_class_name("#{c}")
                     @studs = Student.find(:all, :joins => :studies, :conditions => [" first_name in (?) AND last_name in (?) AND studies.classroom_id = ?" , @st, @st, @class.id ] )
                     @guardian = Guardian.find_by_student_id(@student.id)
                     if @guardian.nil?
                        Guardian.create({:student_id => @student.id, :parent_id => @parent.id })
                     else
                        Guardian.update(@guardian.id, {:student_id => @student.id, :parent_id => @parent.id })
                     end
                 end
             end
             @parent.approved = 1
             @parent.save
             @parent.send_password_approve
             redirect url(:parent_approvals)
          end
     else
       raise @parent.inspect
        @parent.approved = 3
        @parent.save
        Guardian.delete_all(["parent_id = ?", @parent.id])
        redirect url(:approval_review)
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
     @class = Classroom.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "HomePage")
  end
  
end
