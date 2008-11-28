class SpotLights < Application

  layout 'default'
  before :class_students
  before :access_rights
  
  def index
     @spot_lights = SpotLight.find(:all) 
     render
  end
  
  def new
     case request.method
     when :get
        @spot_light = SpotLight.new
        render
       when :post
          @spot = SpotLight.from(params[:file])
          @spot.class_name = params[:spot_light][:class_name]
          @spot.student_name = params[:spot_light][:student_name]
          @spot.content = params[:spot_light][:content]
          @spot.save
          redirect resource(:spot_lights)
       end
  end
  
  def create
    raise params.inspect
    render
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
    render
  end
  
  
  
  private
  
  def class_students
     @class = Classroom.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "HomePage")
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
