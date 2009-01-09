class Calendars < Application
  
  layout 'default'
  before :ensure_authenticated
  before :access_rights, :exclude => [:events, :show]
  before :classrooms, :only => [:events, :show]
  
  def index
     @calendars = Calendar.find(:all)
     render
  end
  
  def new
     @calendar = Calendar.new
     @class_rooms = Classroom.find(:all)
     render
  end
  
  def create
     @class_rooms = Classroom.find(:all)
     @calendar = Calendar.new(params[:calendar])
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
     @class_rooms = Classroom.find(:all) 
     render
  end
  
  def show
     @calendar = Calendar.find(params[:id])
     @classroom = Classroom.find(:first, :conditions => ['class_name = ?', @calendar.class_name])
     render :layout => 'class_change', :id => @classroom.id
  end

  def update
     @class_rooms = Classroom.find(:all)
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
     @cls = Calendar.find(:all, :conditions => ["class_name = ?", params[:class_name] ])
     if params[:class_name] == "All Events"
        @calendars = Calendar.find(:all)
     end
     if params[:class_name].nil?
        @cals = Calendar.find(:all)
     end
     render :layout => 'home'
  end
  
  def preview
     @title = params[:calendar][:title]
     @description = params[:calendar][:description]
     @location = params[:calendar][:location]
     render :layout => 'preview' 
  end
  
  
  private
  
  def classrooms
      @class = Classroom.find(:all)
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
  
end
