class SpotLights < Application

  layout 'default'
  before :find_school
  before :class_students
  before :access_rights
  
  def index
     @spot_lights = @current_school.spot_lights.find(:all, :order => 'created_at DESC')
     render
  end
  
  def new
     @spot_light = SpotLight.new
     render 
  end
  
  def create
     @spot_light = @current_school.spot_lights.new(params[:spot_light])
     @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
     if ( (params[:spot_light][:class_name] != "") && (params[:spot_light][:student_name] != "") )
         if @spot_light.valid?
            if params[:spot_light][:image] != ""
               if @content_types.include?(params[:spot_light][:image][:content_type])
                  @spot_light.save
                  @attachment = Attachment.create( :attachable_id => @spot_light.id,
                                                   :attachable_type => "spot_light", 
                                                   :filename => params[:spot_light][:image][:filename],
                                                   :size => params[:spot_light][:image][:size],
                                                   :content_type => params[:spot_light][:image][:content_type]
                    )
                  File.makedirs("public/uploads/spotlights")
                  FileUtils.mv(params[:spot_light][:image][:tempfile].path, "public/uploads/spotlights/#{@attachment.filename}")
                  redirect resource(:spot_lights)
               else
                  flash[:error1] = "You can only upload images"
                  render :new
               end
            else
               @spot_light.save
               redirect resource(:spot_lights)
            end
         else
            render :new
         end
     else
        flash[:error] = "please select the classroom and student"
        render :new
     end

  end
  
  def show
     if params[:label] == "class_spot_light"
        @selected = "spot_light"
        @select = "classrooms"
        @spot_light = SpotLight.find(params[:id])
        @classroom = @current_school.classrooms.find_by_class_name(@spot_light.class_name)
        render :layout => 'class_change', :id => @classroom.id
     else
        @spot_light = SpotLight.find(params[:id])
        render :layout => 'default'
     end
  end
  
  
  def edit
     @spot_light = SpotLight.find(params[:id])
     @pic = Attachment.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
     render
  end
  
  def update
      @spot_light = SpotLight.find(params[:id])
      @content_types = ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png']
      @pic = Attachment.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
      if params[:spot_light][:image] != ""
         if @content_types.include?(params[:spot_light][:image][:content_type])
            if ( (params[:spot_light][:class_name] != "") && (params[:spot_light][:student_name] != "") )
                if @spot_light.update_attributes(params[:spot_light])
                   @pic = Attachment.find(:first, :conditions => ['attachable_type = ? and attachable_id = ? ', "spot_light", @spot_light.id])
                   unless @pic.nil?
                      @pic.destroy
                   end
                   @attachment = Attachment.create( :attachable_id => @spot_light.id,
                                                      :attachable_type => "spot_light", 
                                                      :filename => params[:spot_light][:image][:filename],
                                                      :size => params[:spot_light][:image][:size],
                                                      :content_type => params[:spot_light][:image][:content_type]
                       )
                   FileUtils.mv(params[:spot_light][:image][:tempfile].path, "public/uploads/spotlights/#{@attachment.filename}")
                   redirect resource(:spot_lights)
                else
                   render :edit
                end
            else
                flash[:error] = "please select classroom and student"
                render :edit
            end
         else
            flash[:error] = "You can only upload images"
            render :edit
         end
      else
          if ( (params[:spot_light][:class_name] != "") && (params[:spot_light][:student_name] != "") )
              if @spot_light.update_attributes(params[:spot_light])
                 redirect resource(:spot_lights)
              else
                 render :edit
              end
          else
              flash[:error] = "please select classroom and student"
              render :edit
          end
      end
  end
  
  def delete
     @spot_light = SpotLight.find(params[:id])
     Attachment.delete_all(['attachable_id = ?', @spot_light.id])
     @spot_light.destroy
     redirect resource(:spot_lights)
  end
   
  def preview
     @student_name = params[:spot_light][:student_name]
     @content = params[:spot_light][:content]
     @class_name = params[:spot_light][:class_name]
     render :layout => 'preview'
  end
  
  
  
  private
  
  def class_students
     @class = Classroom.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "Home Page")
     @students = Student.find(:all)
  end
  
  def access_rights
     @selected = "spotlight"
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('spotlight')
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
