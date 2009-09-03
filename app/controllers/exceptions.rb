class Exceptions < Application
  layout 'login'
  
  # handle NotFound exceptions (404)
  def not_found
    render :layout => "excep"
  end
  
  # handle BadRequest exceptions (400)
   def bad_request
     render :internal_server_error, :format => :html, :layout => false
   end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render :format => :html
  end
  
  # handle all other (500)
   def standard_error
     details = {}
     details['exceptions'] = request.exceptions
     details['data'] = {
       'request_controller' => params[:controller],
       'request_action' => params[:action],
       'request_params' => params,
       'app_name' => "School Yard"
     }
     details['environment'] = request.env.merge( 'process' => $$ )
     details['url'] = "#{request.protocol}#{request.env["HTTP_HOST"]}#{request.uri}"

     email_headers = {
       :from => 'noreply@schoolyardapp.com',
       :to => 'it@schoolyardapp.com',
       :subject => "Error occurred in School Yard"
     }
  
     if Merb.env == "internal_testing"
        run_later do
           ErrorNotifyMailer.dispatch_and_deliver(:error,
                                                email_headers,
                                                details)
        end
       render :internal_server_error, :format => :html, :layout => false
     else
       raise request.exceptions.first
     end
   end

end