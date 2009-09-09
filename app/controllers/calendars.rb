class Calendars < Application

  layout 'default'
  before :find_school
  before :ensure_authenticated
  before :access_rights, :exclude => [:events, :show, :pdf_events]
  before :classrooms, :only => [:events, :show]
  before :classes

  def index
     @all_class_calendars = Calendar.all_calendars(@current_school.id)
    if params[:label] == "classes"
      @classroom = @current_school.classrooms.find_by_id(params[:id])
      raise NotFound unless @classroom
      @calendars = @current_school.calendars.paginate(:all, :conditions => ["class_name = ? ", @classroom.class_name ],
                                                      :per_page => 10,  
                                                      :page => params[:page], 
                                                      :order => 'start_date')   
       # @calendars = @current_school.calendars.paginate(:all, :conditions => ["class_name = ? ", @classroom.class_name ],
       #                                                       :per_page => 10,  
       #                                                       :page => params[:page], 
       #                                                       :order => 'start_date')
      @test = params[:id]
   else
      @c = @current_school.calendars.find(:all)
      @calendars = @c.merge(@all_class_calendars.collect{|x| x.to_a}.flatten)
      @test = "All Classrooms"
    end
    render
  end

  def new
    @calendar = Calendar.new
    render
  end

  def create
    @calendar = @current_school.calendars.new(params[:calendar])
    i=0
    add_calendars
    if @calendar.valid? 
       @calendar.save!
       unless params[:attachment]['file_'+i.to_s].empty?
         type = "Calendar"
         Attachment.file(params.merge(:school_id => @current_school.id), type, @calendar.id)
       end
       if @calendar.class_name == "Schoolwide"
          redirect resource(:calendars)
       else
          @classroom = @current_school.classrooms.find_by_class_name(@calendar.class_name)
          redirect  url(:class_details, :id => @classroom.id, :label => "calendars")
       end
    else
      @start_date = params[:calendar][:start_date]
      @end_date = params[:calendar][:end_date]
      @start_time = params[:calendar][:start_time]
      @end_time = params[:calendar][:end_time]
      @class = params[:calendar][:class_name]
      render :new
    end
  end  
  
  def edit
    @calendar = @current_school.calendars.find_by_id(params[:id])
    raise NotFound unless @calendar
    @attachments = Attachment.calendars(@calendar.id, @current_school.id)
    @allowed = 1 - @attachments.size
    render
  end
  
  def add_calendars
    if params[:calendar][:day_event]
       @calendar.start_time = ""
       @calendar.end_time = ""
       @calendar.day_event = true
    else
       @calendar.start_time = params[:calendar][:start_time]
       @calendar.end_time = params[:calendar][:end_time]
       @calendar.day_event = false
    end
    @calendar.title = params[:calendar][:title]
    @calendar.description = params[:calendar][:description]
    @calendar.location = params[:calendar][:location]
    @calendar.class_name = params[:calendar][:class_name]
    @calendar.start_date = params[:calendar][:start_date]
    @calendar.end_date = params[:calendar][:end_date]
  end
  
  def update
     @calendar = @current_school.calendars.find_by_id(params[:id])
     raise NotFound unless @calendar
     @attachments = Attachment.calendars(@calendar.id, @current_school.id)
     @allowed = 1 - @attachments.size
     i=0
     add_calendars
     if @calendar.valid?
        @calendar.save
        if params[:attachment]
           unless params[:attachment]['file_'+i.to_s].empty?
             type = "Calendar"
             Attachment.file(params.merge(:school_id => @current_school.id), type, @calendar.id)
           end
        end
        if @calendar.class_name == "Schoolwide"
           redirect resource(:calendars)
        else
           @classroom = @current_school.classrooms.find_by_class_name(@calendar.class_name)
           redirect  url(:class_details, :id => @classroom.id, :label => "calendars")
        end
     else
        @start_time = params[:calendar][:start_time]
        @end_time = params[:calendar][:end_time]
        render :edit
     end
  end
  
  def show
    if params[:l] == "calendar"
       @select = "events"
       @calendar = @current_school.calendars.find_by_id(params[:id])
       raise NotFound unless @calendar
       @selected = @calendar.class_name
       render :layout => 'directory'
    else
       @select = "classrooms"
       @selected = "calendars"
       @calendar = @current_school.calendars.find_by_id(params[:id])
       raise NotFound unless @calendar
       if @calendar.class_name == "Schoolwide"
          @classroom = @current_school.classrooms.find_by_id(params[:class])
          raise NotFound unless @classroom
       else
          @class =  @calendar.class_name
          @classroom = @current_school.classrooms.find(:first, :conditions => ['class_name = ?', @calendar.class_name])
       end
       @event = "All Day Event"
       render :layout => 'class_change', :id => @classroom.id
    end
  end

  def delete
    if params[:label] == "attachment"
       @attachment = @current_school.attachments.find(params[:id])
       @calendar = @current_school.calendars.find_by_id(@attachment.attachable_id)
       @attachment.destroy
       @attachments = Attachment.calendars(@calendar.id, @current_school.id)
       @allowed = 1 - @attachments.size
       render :edit, :id => @calendar.id
    else
      @calendar = @current_school.calendars.find_by_id(params[:id])
      raise NotFound unless @calendar
      if @calendar.class_name = "Schoolwide"
         @calendar.destroy
         redirect resource(:calendars)
      elsif @calendar.class_name = "School Wide"
         @calendar.destroy
         redirect resource(:calendars)
      else
         @classroom = @current_school.classrooms.find_by_class_name(@calendar.class_name)
         Attachment.delete_all(['attachable_id = ?', @calendar.id])
         @calendar.destroy
         redirect  url(:class_details, :id => @classroom.id, :label => "calendars")
      end
    end
  end

  def events
    @select = "events"
    @selected = "all_events"
      @all_class_calendars = Calendar.all_calendars(@current_school.id)
    unless params[:id].nil?
      @class = @current_school.classrooms.find(params[:id])
      @cls = @current_school.calendars.find(:all, :conditions => ["class_name = ?", @class.class_name ], :order => 'start_date')
      @selected = @class.class_name
    end
    if params[:l] == "all_events"
      @calendars = @current_school.calendars.paginate(:all, :per_page => 10,  :page => params[:page], :order => 'start_date')
    end
    render :layout => 'directory'
  end

  def preview
    @date = Date.today
    @select = "classrooms"
    if params[:calendar][:class_name] == "Schoolwide"
       @classroom =  @current_school.classrooms.find(:first, :conditions => ['class_type = ?', "Classes" ])
    else
       @classroom = @current_school.classrooms.find_by_class_name(params[:calendar][:class_name])
    end
    render :layout => 'class_change', :id => @classroom.id
  end

  def pdf_events
    if params[:label] == "single"
      @calendar = @current_school.calendars.find_by_id(params[:id])
      raise NotFound unless @calendar
      pdf = pdf_prepare("single", @calendar)
      send_data(pdf.render, :filename => "#{@calendar.class_name}.pdf", :type => "application/pdf")
    else
      @classroom = @current_school.classrooms.find_by_id(params[:id])
      raise NotFound unless @classroom
      @calendars = @current_school.calendars.find(:all, :conditions => ["class_name = ?", @classroom.class_name ])
      @all_class_calendars = Calendar.all_calendars(@current_school.id)
      pdf = pdf_prepare("multiple", @calendars)
      send_data(pdf.render, :filename => "#{@classroom.class_name}.pdf", :type => "application/pdf")
    end
  end

  private

  def classrooms
    @class = @current_school.active_classrooms
    room = @class.collect{|x| x.class_name }
    @classrooms = room.insert(0, "All Events")
  end
  
  def classes
     classes = @current_school.active_classrooms
     room = classes.collect{|x| x.class_name }
     @class_rooms = room.insert(0, "Schoolwide")
  end

  def access_rights
    @selected = "calendars"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('calendar')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @access_people.each do |f|
      have_access = (f.all == true) || (f.access_id == @ann.id)
      break if have_access
    end
    unless have_access
      redirect resource(:homes)
    end
  end

  def pdf_prepare(value, calendar)
    pdf = PDF::Writer.new
    pdf.select_font "Helvetica"
    pdf.text "#{@current_school.school_name}", :font_size => 20, :justification => :center
    if value == "multiple"
      @calendars.each do |calendar|
        con = calendar.description
        con = con.gsub("”", "") 
        con = con.gsub("“", "")
        con = con.gsub("’", "")
        con = con.gsub("‘", "")
        con = con.gsub("’", "")
        con = con.gsub("– ", "")
        con = con.gsub(/[^a-zA-Z0-9-]/, " ")
        pdf.text "<b>Title</b>"  + ":" + "" + "#{calendar.title}", :font_size => 10, :justification => :left, :spacing => 2
        pdf.text "<b>Description</b>" + ":" + "" +  con, :font_size => 10, :justification => :left
        pdf.text "<b>Location</b>" + ":" + "" + "#{calendar.location}", :font_size => 10, :justification => :left
        pdf.text "<b>Start Date</b>" + ":" + "" + "#{calendar.start_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
      end
       @all_class_calendars.each do |calendar|
          con = calendar.description
          con = con.gsub("”", "") 
          con = con.gsub("“", "")
          con = con.gsub("’", "")
          con = con.gsub("‘", "")
          con = con.gsub("’", "")
          con = con.gsub("– ", "")
          con = con.gsub(/[^a-zA-Z0-9-]/, " ")
          pdf.text "<b>Title</b>"  + ":" + "" + "#{calendar.title}", :font_size => 10, :justification => :left, :spacing => 2
          pdf.text "<b>Description</b>" + ":" + "" +  con, :font_size => 10, :justification => :left
          pdf.text "<b>Location</b>" + ":" + "" + "#{calendar.location}", :font_size => 10, :justification => :left
          pdf.text "<b>Start Date</b>" + ":" + "" + "#{calendar.start_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
        end
      pdf
    else
       con = @calendar.description
       con = con.gsub("”", "") 
       con = con.gsub("“", "")
       con = con.gsub("’", "")
       con = con.gsub("‘", "")
       con = con.gsub("’", "")
       con = con.gsub("– ", "")
       con = con.gsub(/[^a-zA-Z0-9-]/, " ")
      pdf.text "<b>Title</b>"  + ":" + "" + "#{@calendar.title}", :font_size => 10, :justification => :left
      pdf.text "<b>Description</b>" + ":" + "" +  con, :font_size => 10, :justification => :left
      pdf.text "<b>Location</b>" + ":" + "" + "#{@calendar.location}", :font_size => 10, :justification => :left
      pdf.text "<b>Start Date</b>" + ":" + "" + "#{@calendar.start_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
      pdf
    end
  end


end
