class Exceptions < Application
  layout 'login'
  # handle NotFound exceptions (404)
  def not_found
    render :layout => "excep"
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    render :format => :html
  end

end