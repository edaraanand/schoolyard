class Forms < Application
  
  layout 'default'
  
  before :classrooms
  before :access_rights
  
  def index
    @forms = Form.find(:all)
    render
  end
  
  def new
    @form = Form.new
    render
  end
  
  def create
    puts "Naidu".inspect
    #raise params.inspect
    @form = Form.new(params[:form])
    raise @form.inspect
    render
  end
  
  
  private
  
  def classrooms
    classes = Classroom.find(:all)
    room = classes.collect{|x| x.class_name }
    @classrooms = room.insert(0, "All Classes")
    @years = (1999..2025).to_a
  end
  
  def access_rights
     have_access = false
     @view = Access.find_by_name('view_all')
     @ann = Access.find_by_name('forms')
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
