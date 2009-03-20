class SpotLights < Application

  layout 'default'
  before :class_students
  before :access_rights
  
  def index
     @spot_lights = SpotLight.find(:all) 
     render
  end
  
  def new
    #case request.method
    # when :get
        @spot_light = SpotLight.new
        @attachment = Attachment.new
      #  render
     #when :post
      #    @spot = SpotLight.from(params[:file])
       #   @spot.class_name = params[:spot_light][:class_name]
        #  @spot.student_name = params[:spot_light][:student_name]
         # @spot.content = params[:spot_light][:content]
          #@spot.save
          #redirect resource(:spot_lights)
       #end
       render 
  end
  
  def create
    #raise params.inspect
    @spot_light = SpotLight.new(params[:spot_light])
    i=0
    if @spot_light.valid?
       unless params[:attachment]['file_'+i.to_s].empty?
            @spot_light.save
            @attachment = Attachment.create( :attachable_type => "SpotLight",
                                        :attachable_id => @spot_light.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
             )
              File.makedirs("public/uploads/#{@attachment.id}")
              FileUtils.mv(params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
              redirect resource(:spot_lights)
        else
            flash[:error] = "please upload a picture"
            render :new
        end
    else
      render :new
    end
  end
  
  def edit
    @spot_light = SpotLight.find(params[:id])
    render
  end
  
  def update
     @spot_light = SpotLight.find(params[:id])
     render
  end
  
  def delete
      SpotLight.find(params[:id]).destroy
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
