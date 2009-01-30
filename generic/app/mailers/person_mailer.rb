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
  
  def password_staff
     puts "Damn".inspect
     @staff = params
     @current_school = @staff.school
     puts @current_school.inspect
     render_mail :html => :password_staff, :layout => nil
     puts "hiphip".inspect
  end
  
 
      
end
