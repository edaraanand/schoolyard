class Calendars < Application
  
  layout 'default'
  before :find_school
  before :ensure_authenticated
  before :access_rights, :exclude => [:events, :show]
  before :classrooms, :only => [:events, :show]
  
  def index
    @calendars = @current_school.calendars.find(:all)
     render
  end
  
  def new
     @calendar = Calendar.new
     @class_rooms = @current_school.classrooms.find(:all)
     render
  end
  
  def create
     @class_rooms = @current_school.classrooms.find(:all)
     @calendar = @current_school.calendars.new(params[:calendar])
     if @calendar.save
        unless params[:calendar][:attachment].empty?
          @attachment = Attachment.create( :attachable_type => "Calendar",
                                        :attachable_id => @calendar.id,
                                        :filename => params[:calendar][:attachment][:filename],
                                        :content_type => params[:calendar][:attachment][:content_type],
                                        :size => params[:calendar][:attachment][:size]
            )
           File.makedirs("public/uploads/#{@attachment.id}")
           FileUtils.mv(params[:calendar][:attachment][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
        end
	      redirect resource(:calendars)
     else
        @start_time = params[:calendar][:start_time]
        @end_time = params[:calendar][:end_time]
	      render :new 
     end
  end

  def edit
     @calendar = Calendar.find(params[:id])
     @class_rooms = @current_school.classrooms.find(:all) 
     render
  end
  
  def show
     @calendar = Calendar.find(params[:id])
     @classroom = Classroom.find(:first, :conditions => ['class_name = ?', @calendar.class_name])
     @event = "All Day Event"
     render :layout => 'class_change', :id => @classroom.id
  end

  def update
     @class_rooms = @current_school.classrooms.find(:all)
     @calendar = Calendar.find(params[:id])
     if @calendar.update_attributes(params[:calendar])
         Attachment.delete_all(['attachable_id = ?', @calendar.id])
         unless params[:calendar][:attachment].empty?
             @attachment = Attachment.create( :attachable_type => "Calendar",
                                        :attachable_id => @calendar.id,
                                        :filename => params[:calendar][:attachment][:filename],
                                        :content_type => params[:calendar][:attachment][:content_type],
                                        :size => params[:calendar][:attachment][:size]
              )
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
  end
  
  def delete
     @calendar = Calendar.find(params[:id])
     Attachment.delete_all(['attachable_id = ?', @calendar.id])
     @calendar.destroy
     redirect resource(:calendars)
  end
  
  def events
     @cls = @current_school.calendars.find(:all, :conditions => ["class_name = ?", params[:class_name] ])
     if params[:class_name] == "All Events"
        @calendars = @current_school.calendars.find(:all)
     end
     if params[:class_name].nil?
        @cals = @current_school.calendars.find(:all)
     end
     render :layout => 'home'
  end
  
  def preview
     @title = params[:calendar][:title]
     @description = params[:calendar][:description]
     @location = params[:calendar][:location]
     render :layout => 'preview' 
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
      @class = @current_school.classrooms.find(:all)
      room = @class.collect{|x| x.class_name }
      @classrooms = room.insert(0, "All Events")
  end
   
  def access_rights
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
      pdf.text "#{@current_school.school_name}", :font_size => 40, :justification => :center
      if value == "multiple"
          @calendars.each do |calendar|
              pdf.text "Title : #{calendar.title}", :font_size => 10, :justification => :left
              pdf.text "Description : #{calendar.description}", :font_size => 10, :justification => :left
              pdf.text "Location : #{calendar.location}", :font_size => 10, :justification => :left
              pdf.text "Start Date : #{calendar.start_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
          end
          pdf
      else
           pdf.text "Title : #{@calendar.title}", :font_size => 10, :justification => :left
           pdf.text "Description : #{@calendar.description}", :font_size => 10, :justification => :left
           pdf.text "Location : #{@calendar.location}", :font_size => 10, :justification => :left
           pdf.text "Start Date : #{@calendar.start_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
           pdf
      end
  end
  
  
end
