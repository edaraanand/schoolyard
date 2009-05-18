class PersonMailer < Merb::MailController

  
  def notify_on_event
     # use params[] passed to this controller to get data
     # read more at http://wiki.merbivore.com/pages/mailers
     render_mail
  end
  
  def sign_up
    @parent = params
    @current_school = @parent.school
    render_mail  :html => :sign_up, :layout => nil
  end
  
  def new_password
    @parent = params
    @current_school = @parent.school
    render_mail :html => :new_password, :layout => nil
  end
  
  def forgot_password
     @person = params
     @current_school = @person.school
     render_mail :html => :forgot_password, :layout => nil
  end
  
  def new_staff_password
     @staff = params
     @current_school = @staff.school
     render_mail :html => :new_staff_password, :layout => nil
  end
  
  def notify_staff_details
      @staff = params
      @current_school = @staff.school
      render_mail :html => :notify_staff_details, :layout => nil
  end

  def feedback
    @announcement = params
    @current_school = @announcement.school
    render_mail :html => :feedback, :layout => nil
  end

  def reply_person
    @announcement = params
    @current_school = @announcement.school
    render_mail :html => :feedback, :layout => nil
  end
  
  
end
