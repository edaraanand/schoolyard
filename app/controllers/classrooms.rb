class Classrooms < Application
  
  def index
    render
    
  end
  
  def new
     @classroom = Classroom.new
     @classtypes = Classtype.find(:all)
     @classrooms = Classroom.find(:all)
     @teachers = @classroom.people.find(:all, :conditions => ['role=?', 'teacher'])
     render
  end
  
  def create
     
     render
  end
  
end
