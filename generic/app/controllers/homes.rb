class Homes < Application
  
    before :ensure_authenticated
    layout 'home'
    before :find_school
    before :selected, :exclude => [:help]
    
  def index
    @date = Date.today
    @announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ? and expiration >= ?", 'Home Page', true, true, @date], :order => "created_at DESC", :limit => 4 )
    @from_principals = @current_school.announcements.find(:all, :conditions => ["label = ? and expiration >= ?", 'from_principal', @date], :limit => 2)
    @external_links = @current_school.external_links.find(:all, :conditions => ['label = ?', "Home Page"])
    @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ["access_name = ?", "Home Page"])
    #@from_principals = @current_school.announcements.find(:all, :conditions => ["label = ?", "from_principal"], :limit => 2)
    # @announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'Home Page', true, true], :order => "created_at DESC", :limit => 4 )
    @classrooms = @current_school.classrooms.find(:all, :conditions => ['activate = "1"'], :order => "class_name ASC")
    @classes = @current_school.classrooms.find(:all, :conditions =>['class_type = "Classes" and activate = "1"'], :order => "class_name ASC")
    @extracurricular = @current_school.classrooms.find(:all, :conditions =>['class_type = "Extra Cirrcular" and activate = "1"'], :order => "class_name ASC")
    
    render
  end
  
  def principal_articles
    @from_principals = @current_school.announcements.paginate(:all, :conditions => ['label = ?', 'from_principal'], :per_page => 4, :page => params[:page] )
    @announcements = @current_school.announcements.paginate(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'Home Page', true, true], :order => "created_at DESC", :per_page => 4, :page => params[:page] )
     render
  end
  
  def show
    if params[:label] == "class_ann"
       @selected = "announcements"
       @announcement = Announcement.find(params[:id])
       @classroom = @current_school.classrooms.find(:first, :conditions => ['class_name = ?', @announcement.access_name] )
       render :layout => 'class_change', :id => @classroom.id
    elsif params[:label] == "sports_announcement"
       @selected = "announcements"
       @select = "sports"
       @announcement = Announcement.find(params[:id])
       render :layout => 'sports'
    else
       @announcement = Announcement.find(params[:id])
       render :layout => 'home'
    end
  end
 
  def help
    @select = "contact"
    render :layout => 'help'
  end
  
  def bio
    if params[:label] == "classes"
       @selected = "bio_classes"
       @select = "classrooms"
       @classroom = @current_school.classrooms.find(params[:id])
       render :layout => 'class_change', :id => @classroom.id
    else
      @selected = "bio_sports"
      @select = "sports"
      @classroom = @current_school.classrooms.find(:first, :conditions => ['class_name = ?', "Sports"])
      render :layout => 'sports'
    end
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


