class Calendars < Application

  layout 'default'
  before :find_school
  before :ensure_authenticated
  before :access_rights, :exclude => [:events, :show, :pdf_events]
  before :classrooms, :only => [:events, :show]
  before :classes

  def index
    @week = (params[:week] || 0).to_i
    if params[:label] == "classes"
       @classroom = @current_school.classrooms.find_by_id(params[:id]) rescue NotFound
       @calendars = Calendar.current_week_calendars(@current_school.id, @classroom.class_name, @week)
       @test = params[:id]
    else
       @calendars = Calendar.all_week_calendars(@current_school.id, @week)
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
      @check = params[:calendar][:day_event]
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
    if params[:ref] == "calendars"
       @select = "events"
       @calendar = @current_school.calendars.find_by_id(params[:id]) rescue NotFound
       @selected = @calendar.class_name
       render :layout => 'directory'
    else
       @select = "classrooms"
       @selected = "calendars"
       @calendar = @current_school.calendars.find_by_id(params[:id]) rescue NotFound
       if @calendar.class_name == "Schoolwide"
          @classroom = @current_school.classrooms.find_by_id(params[:class]) rescue NotFound
       else
          @classroom = @current_school.classrooms.find_by_class_name(@calendar.class_name)
       end
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
    @week = (params[:week] || 0).to_i
    @select = @selected = "events"
    if params[:id]
      @class = @current_school.classrooms.find_by_id(params[:id]) rescue NotFound
      @calendars = Calendar.current_week_calendars(@current_school.id, @class.class_name, @week)
      @selected = @class.class_name
    else 
      @calendars = Calendar.all_week_calendars(@current_school.id, @week)
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
      @calendar = @current_school.calendars.find_by_id(params[:id]) rescue NotFound
      pdf = pdf_prepare("single", @calendar)
      send_data(pdf.render, :filename => "#{@calendar.class_name}.pdf", :type => "application/pdf")
    else
      @classroom = @current_school.classrooms.find_by_id(params[:id]) rescue NotFound
      @calendars = Calendar.all_calendars(@current_school.id, @classroom.class_name)
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
        con = san_content(calendar.description)
        con = con.gsub("”", "") 
        con = con.gsub("“", "")
        con = con.gsub("’", "")
        con = con.gsub("‘", "")
        con = con.gsub("’", "")
        con = con.gsub("– ", "")
        con = con.gsub(/[^a-zA-Z0-9-]/, " ")
        pdf.text "<b>Start Date</b>" + ":" + "" + "#{calendar.start_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left, :spacing => 2
        pdf.text "<b>Title</b>"  + ":" + "" + "#{calendar.title}", :font_size => 10, :justification => :left
        pdf.text "<b>Location</b>" + ":" + "" + "#{calendar.location}", :font_size => 10, :justification => :left
        pdf.text "<b>Description</b>" + ":", :spacing => 2
        pdf.text "<b> </b>", :spacing => 2
        con.split('br').map do |c| 
          pdf.text c.strip, :font_size => 10, :justification => :left
        end
        pdf.text "<b></b>"
        pdf.text "---------------------------------------------", :justification => :center
        pdf.text "<b></b>"
      end
      pdf
    else
       con = san_content(@calendar.description)
       con = con.gsub("”", "") 
       con = con.gsub("“", "")
       con = con.gsub("’", "")
       con = con.gsub("‘", "")
       con = con.gsub("’", "")
       con = con.gsub("– ", "")
       con = con.gsub(/[^a-zA-Z0-9-]/, " ")
       pdf.text "<b>Start Date</b>" + ":" + "" + " " + "#{@calendar.start_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left, :spacing => 2
       pdf.text "<b>Title</b>"  + ":" + "" +  " " + "#{@calendar.title}", :font_size => 10, :justification => :left
       pdf.text "<b>Location</b>" + ":" + "" +  " " + "#{@calendar.location}", :font_size => 10, :justification => :left
       pdf.text "<b>Description</b>" + ":", :spacing => 2
       con.split('br').map do |c| 
          pdf.text c.strip, :font_size => 10, :justification => :left
       end
       pdf
    end
  end


end
