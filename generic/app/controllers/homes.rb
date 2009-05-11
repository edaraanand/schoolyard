class Homes < Application
  
    before :ensure_authenticated
    layout 'home'
    before :find_school
    before :selected, :exclude => [:help]
    
  def index
    @date = Date.today
    @all_announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'Home Page', true, true])
    @announcements = @current_school.announcements.find(:all, :conditions => ["access_name = ? and approved = ? and approve_announcement = ? and expiration >= ?", 'Home Page', true, true, @date], :order => "created_at DESC", :limit => 4 )
    @all_from_principals = @current_school.announcements.find(:all, :conditions => ["label = ?", 'from_principal'])
    @from_principals = @current_school.announcements.find(:all, :conditions => ["label = ? and expiration >= ?", 'from_principal', @date], :order => "created_at DESC", :limit => 2)
    @external_links = @current_school.external_links.find(:all, :conditions => ['label = ?', "Home Page"])
    @welcome_messages = @current_school.welcome_messages.find(:all, :conditions => ["access_name = ?", "Home Page"])
    @classrooms = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true], :order => "class_name ASC")
    @classes = @current_school.classrooms.find(:all, :conditions =>['class_type = ? and activate = ?', "Classes", true], :order => "class_name ASC")
    @extracurricular = @current_school.classrooms.find(:all, :conditions =>['class_type = ? and activate = ?', "Extra Cirrcular", true ], :order => "class_name ASC")
    @spot_light = @current_school.spot_lights.find(:first, :conditions => ['class_name = ?', "Home Page"], :order => 'created_at DESC')
    render
  end
  
  def principal_articles
      @from_principals = @current_school.announcements.paginate(:all, 
                                                                :conditions => ['label = ?', 'from_principal'], 
                                                                :order => "created_at DESC",
                                                                :per_page => 10,
                                                                :page => params[:page] )
      @announcements = @current_school.announcements.paginate(:all, 
                                                              :conditions => ["access_name = ? and approved = ? and approve_announcement = ?", 'Home Page', true, true], 
                                                              :order => "created_at DESC", 
                                                              :per_page => 10,
                                                              :page => params[:page] )
      render
  end
  
  def show
    if params[:label] == "class_ann"
       @select = "classrooms" 
       @selected = "announcements"
       @announcement = @current_school.announcements.find(params[:id])
       @classroom = @current_school.classrooms.find_by_class_name(@announcement.access_name)
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
  
  
  def home_spot_light
     @spot_light = @current_school.spot_lights.find(params[:l])
     render
  end
  
  def lights
     @spot_lights = @current_school.spot_lights.paginate(:all, 
                                                      :conditions => ['class_name = ?', "Home Page"],
                                                      :per_page => 3,
                                                      :page => params[:page],
                                                      :order => 'created_at DESC')
      render
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


