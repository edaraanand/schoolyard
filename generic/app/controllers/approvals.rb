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
    @announcement.approved = @announcement.approve_announcement = true
    @announcement.save 
    redirect resource(:approvals)
  end
  
  def reject
    @announcement = Announcement.find(params[:id])
    @announcement.approved = @announcement.approve_announcement = false
    @announcement.save 
    redirect resource(:approvals)
  end
  
  def preview
     @title = params[:announcement][:title]
     @content = params[:announcement][:content]
     render :layout => 'preview'
  end
  
  def parent_approvals
    @parents = Parent.find(:all, :conditions => ['approved = ?', false] )
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
          #@studes = @parent.students
          #raise @studes.inspect
          #raise params.inspect
          @parent.approved = true
          @parent.save
          @parent.send_password_approve
          redirect url(:parent_approvals)
       end
                       
    else
      redirect url(:approval_review)
    end
   
  end
  
  def parent_reject
    raise "Eshwar".inspect
     @parent = Parent.find(params[:id])
     @students = Registration.find(:all, :conditions => ['parent_id = ?', @parent.id])
     @students.each do |f|
        f.destroy
     end
     redirect url(:parent_approvals)   
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
