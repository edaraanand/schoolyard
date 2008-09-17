class MerbAuth::UserMailer < Merb::MailController
  
  controller_for_slice MerbAuth, :templates_for => :mailer, :path => "views"
    
  
  def forgot_password
       puts "Huuuuuuuuu"
     @ivar = params[MerbAuth[:single_resource]]
     puts @ivar.inspect
     instance_variable_set("@#{MerbAuth[:single_resource]}", @ivar )
     render_mail :text => :forgot_password, :layout => nil
  end 
   

end
