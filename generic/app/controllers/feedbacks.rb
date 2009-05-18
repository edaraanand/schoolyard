class Feedbacks < Application
  
  before :find_school
  layout 'default'
  before :access_rights, :exclude => [:new, :create]

  def index
    @announcements = @current_school.announcements.find(:all, :conditions => ['label = ?', "feedback"], :order => "created_at DESC")
    render :layout => 'default'
  end
  
  def new
    @announcement = Announcement.new
    render :layout => 'home'
  end
  
  def create
     @announcement = session.user.announcements.build(params[:announcement])
      if @announcement.valid?
         @announcement.school_id = @current_school.id
         @announcement.label = "feedback"
         @announcement.approved = false
         @announcement.approve_announcement = true
         @announcement.save
         redirect url(:homes)
      else
         render :new
      end
  end
  
  def show
    @announcement = @current_school.announcements.find(params[:id])
    render 
  end
  
  def feedback_reply
    @announcement = @current_school.announcements.find(params[:id])
    if params[:approvetype] == "reply"
       @announcement.approve_comments = params[:announcement][:approve_comments]
       @announcement.approved_by = session.user.id  # this is for storing who replied the feedback
       @announcement.save
       @announcement.reply_person
    else
       @announcement.approve_comments = params[:announcement][:approve_comments]
       @announcement.approved = @announcement.approve_announcement = true
       @announcement.save
       @announcement.feedback_email
    end
    redirect url(:feedbacks)
  end
  
   private

  def access_rights
    @selected = "feedback"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('feedback')
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
