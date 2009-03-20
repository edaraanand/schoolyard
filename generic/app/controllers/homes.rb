class Homes < Application
  
    before :ensure_authenticated
    layout 'home'
    before :find_school
    before :selected, :exclude => [:help]
    
  def index
    @date = Date.today
   # @announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ? and expiration >= ?", 'Home Page', true, true, @date], :limit => 2 )
   # @from_principals = @current_school.announcements.find(:all, :conditions => ["label = ? and expiration >= ?", 'from_principal', @date], :limit => 2)
    @external_links = @current_school.external_links.find(:all, :conditions => ['label = ?', "Home Page"])
    @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ["access_name = ?", "Home Page"])
    @from_principals = @current_school.announcements.find(:all, :conditions => ["label = ?", "from_principal"], :limit => 2)
    @announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'Home Page', true, true], :order => "created_at DESC", :limit => 4 )
    @classrooms = @current_school.classrooms.find(:all)
    render
  end
  
  def principal_articles
     @from_principals = @current_school.announcements.find(:all, :conditions => ['label = ?', 'from_principal'] )
     @announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'Home Page', true, true], :order => "created_at DESC" )
     render
  end
  
  def show
    @announcement = Announcement.find(params[:id])
    render
  end
 
  def help
    @select = "contact"
    render :layout => 'help'
  end
  
  def download
     @attachment = Attachment.find(params[:id])
     send_file("#{Merb.root}/public/uploads/#{@attachment.id}/#{@attachment.filename}") 
  end
  
  def pdf_download
     @announcement = Announcement.find(params[:id])
     pdf = prepare_pdf(@announcement)
     send_data(pdf.render, :filename => "#{@announcement.title}.pdf", :type => "application/pdf")
  end
  
  private
  
  def prepare_pdf(announcement)
      pdf = PDF::Writer.new
      pdf.select_font "Helvetica"
      pdf.text "#{@current_school.school_name}", :font_size => 15
      pdf.text " "
      pdf.text "<b>#{@announcement.title} </b>", :font_size => 20
      pdf.text "Published #{@announcement.created_at.strftime('%B %d %Y')}", :font_size => 10
      pdf.text " "
            pdf.text " "      
      pdf.text "#{@announcement.content}" , :font_size => 15
      pdf
  end
  
  def selected
     @select = "home"
  end
  
end


