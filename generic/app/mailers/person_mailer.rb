class PersonMailer < Merb::MailController

  def notify_on_event
   
    # use params[] passed to this controller to get data
    # read more at http://wiki.merbivore.com/pages/mailers
    render_mail
  end
  
  def sign_up
    @parent = params
    render_mail  :html => :sign_up, :layout => nil
  end
  
  def new_password
    @parent = params
    render_mail :html => :new_password, :layout => nil
  end
  
  def forgot_password
     @person = params
     render_mail :html => :forgot_password, :layout => nil
  end
  
  def password_staff
     @staff = params
     render_mail :html => :password_staff, :layout => nil
  end
  
end
