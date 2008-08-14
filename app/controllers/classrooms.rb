class Classrooms < Application
  
  def index
    render
  end
  
  def new
     @class_room = Classroom.new
     @class_types = Classtype.find(:all)
     render
  end
  
  def create
     render
  end
  
end
