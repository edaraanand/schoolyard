class Calendars < Application
  
  layout 'default'
  before :find_school
  before :ensure_authenticated
  before :access_rights, :exclude => [:events, :show]
  before :classrooms, :only => [:events, :show]
  
  def index
     @calendars = @current_school.calendars.find(:all, :order => 'start_date')
     render
  end
  
  def new
     @calendar = Calendar.new
     @class_rooms = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
     render
  end
  
  def create
     @class_rooms = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
     @calendar = @current_school.calendars.new(params[:calendar])
     i=0
     if params[:calendar][:class_name] != ""
        if @calendar.valid?
           @calendar.save
           unless params[:attachment]['file_'+i.to_s].empty?
              @attachment = Attachment.create( :attachable_type => "Calendar",
                                        :attachable_id => @calendar.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
               )
               File.makedirs("public/uploads/#{@attachment.id}")
               FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
           end
	         redirect resource(:calendars)
        else
           @start_time = params[:calendar][:start_time]
           @end_time = params[:calendar][:end_time]
	         render :new 
        end
     else
        flash[:error] = "Please select the option"
        render :new
     end
  end

  def edit
     @calendar = Calendar.find(params[:id])
     @class_rooms = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true]) 
     @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @calendar.id, "Calendar"])
     @allowed = 1 - @attachments.size
     render
  end
  
  def show
    if params[:l] == "calendar"
       @select = "events"
       @calendar = Calendar.find(params[:id])
       @selected = @calendar.class_name 
       render :layout => 'directory'
    else
       @select = "classrooms"
       @selected = "calendars"
       @calendar = Calendar.find(params[:id])
       @classroom = Classroom.find(:first, :conditions => ['class_name = ?', @calendar.class_name])
       @event = "All Day Event"
       render :layout => 'class_change', :id => @classroom.id
    end
  end

  def update
     @class_rooms = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
     @calendar = Calendar.find(params[:id])
     @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @calendar.id, "Calendar"])
     @allowed = 1 - @attachments.size
     i=0
     if params[:attachment]
        if params[:calendar][:class_name] != ""
           if @calendar.update_attributes(params[:calendar])
              unless params[:attachment]['file_'+i.to_s].empty?
                  @attachment = Attachment.create( :attachable_type => "Calendar",
                                        :attachable_id => @calendar.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
                   )
                   File.makedirs("public/uploads/#{@attachment.id}")
                   FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
              end
              if @calendar.day_event == true
	               @calendar.start_time = nil
	               @calendar.end_time = nil
              end
	            @calendar.save
	            redirect resource(:calendars)
           else
              @start_time = params[:calendar][:start_time]
              @end_time = params[:calendar][:end_time]
	            render :edit
           end
        else
           flash[:error] = "Please select the option"
           render :edit
        end
     else
         if params[:calendar][:class_name] != ""
            if @calendar.update_attributes(params[:calendar])
               if @calendar.day_event == true
	                @calendar.start_time = nil
	                @calendar.end_time = nil
               end
	             @calendar.save
	             redirect resource(:calendars)
            else
               @start_time = params[:calendar][:start_time]
               @end_time = params[:calendar][:end_time]
	             render :edit
            end
         else
            flash[:error] = "Please select the option"
            render :edit
         end
      end
  end
  
  def delete
    if params[:label] == "attachment"
        @attachment = Attachment.find(params[:id])
        @calendar = Calendar.find_by_id(@attachment.attachable_id)
        @class_rooms = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
        @attachment.destroy
        @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @calendar.id, "Calendar"])
        @allowed = 1 - @attachments.size
        render :edit, :id => @calendar.id
    else
        @calendar = Calendar.find(params[:id])
        Attachment.delete_all(['attachable_id = ?', @calendar.id])
        @calendar.destroy
        redirect resource(:calendars)
    end
  end
  
  def events
     @select = "events"
     @selected = "all_events"
     unless params[:id].nil?
         @class = @current_school.classrooms.find(params[:id])
         @cls = @current_school.calendars.find(:all, :conditions => ["class_name = ?", @class.class_name ], :order => 'start_date')
         @selected = @class.class_name 
     end
     if params[:l] == "all_events"
        @calendars = @current_school.calendars.find(:all, :order => 'start_date')
     end
     render :layout => 'directory'
  end
  
  def preview
     @date = Date.today
     @select = "classrooms"
     if params[:calendar][:class_name] != nil
         @classroom = @current_school.classrooms.find_by_class_name(params[:calendar][:class_name])
         render :layout => 'class_change', :id => @classroom.id
     else
       raise NotFound
     end
  end
  
  def pdf_events
    if params[:label] == "single"
       @calendar = Calendar.find(params[:id])
       pdf = pdf_prepare("single", @calendar)
       send_data(pdf.render, :filename => "#{@calendar.class_name}.pdf", :type => "application/pdf")
    else
       @classroom = Classroom.find(params[:id])
       @calendars = @current_school.calendars.find(:all, :conditions => ["class_name = ?", @classroom.class_name ])
       pdf = pdf_prepare("multiple", @calendars)
       send_data(pdf.render, :filename => "#{@classroom.class_name}.pdf", :type => "application/pdf")
    end
  end
  
  private
  
  def classrooms
      @class = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
      room = @class.collect{|x| x.class_name.titleize }
      @classrooms = room.insert(0, "All Events")
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
              pdf.text "<b>Title</b>"  + ":" + "" + "#{calendar.title}", :font_size => 10, :justification => :left
              pdf.text "<b>Description</b>" + ":" + "" +  "#{calendar.description}", :font_size => 10, :justification => :left
              pdf.text "<b>Location</b>" + ":" + "" + "#{calendar.location}", :font_size => 10, :justification => :left
              pdf.text "<b>Start Date</b>" + ":" + "" + "#{calendar.start_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
          end
          pdf
      else
           pdf.text "<b>Title</b>"  + ":" + "" + "#{@calendar.title}", :font_size => 10, :justification => :left
           pdf.text "<b>Description</b>" + ":" + "" +  "#{@calendar.description}", :font_size => 10, :justification => :left
           pdf.text "<b>Location</b>" + ":" + "" + "#{@calendar.location}", :font_size => 10, :justification => :left
           pdf.text "<b>Start Date</b>" + ":" + "" + "#{@calendar.start_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
           pdf
      end
  end
  
  
end
