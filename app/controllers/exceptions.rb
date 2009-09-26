class Exceptions < Application
   layout 'login'
   
   skip_before :login_required
   skip_before :find_school
   
   after :send_exception, :only => [:standard_error, :runtime_error]
   
   def send_exception
     details = {}
     details['exceptions'] = request.exceptions
     details['data'] = {
       'request_controller' => params[:controller],
       'request_action' => params[:action],
       'request_params' => params,
       'app_name' => "SchoolYard"
     }
     details['environment'] = request.env.merge( 'process' => $$ )
     details['url'] = "#{request.protocol}://#{request.env["HTTP_HOST"]}#{request.uri}"
     
     email_headers = {
       :from => 'noreply@schoolyardapp.com',
       :to => Schoolapp.config(:exception_to_address),
       :subject => "SchoolYard Exception (#{ details['url']}) #{Merb.env}"
     }
     
    run_later do
       ErrorNotifyMailer.dispatch_and_deliver(:error,
                                            email_headers,
                                            details)
    end
     
   end
   # handle NotFound exceptions (404)
   
   
   #this is not needed
#   def not_found
#     render :layout => "excep"
#   end
   
   # handle BadRequest exceptions (400)
    def bad_request
      render :internal_server_error, :format => :html, :layout => false
    end
     
   # handle NotAcceptable exceptions (406)
   def not_acceptable
     render :format => :html
   end
   
   def standard_error
     render :internal_server_error, :format => :html, :layout => false
   end
     
   def runtime_error
     render :internal_server_error, :format => :html, :layout => false
   end
   
    #   
    # # handle NotFound exceptions (404)
    #  def not_found
    #    render :format => :html
    #  end
    # 
    #  # handle NotAcceptable exceptions (406)
    #  def not_acceptable
    #    render :format => :html
    #  end
    # 
   
end