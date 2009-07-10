class ErrorNotifyMailer < Merb::MailController

  def notify_on_event
    # use params[] passed to this controller to get data
    # read more at http://wiki.merbivore.com/pages/mailers
    render_mail
  end
  
  def error
     # use params[] passed to this controller to get data
     # read more at http://wiki.merbivore.com/pages/mailers
     @exceptions = params["exceptions"]
     @data = params["data"]
     @environment = params["environment"]
     @url = params["url"]
     render_mail
  end
  
end
