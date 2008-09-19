class MerbAuth::UserMailer < Merb::MailController
  
  controller_for_slice MerbAuth, :templates_for => :mailer, :path => "views"
    
  
  def forgot_password
     @ivar = params[MerbAuth[:single_resource]]
     instance_variable_set("@#{MerbAuth[:single_resource]}", @ivar )
     render_mail :html => :forgot_password, :layout => nil
  end 
   
  def signup
      puts "Hip Hip"
      puts @user.inspect
      @ivar = params[MerbAuth[:single_resource]]
      puts @ivar.inspect
      instance_variable_set("@#{MerbAuth[:single_resource]}", @ivar )
      render_mail :html => :signup, :layout => nil
  end 

end
