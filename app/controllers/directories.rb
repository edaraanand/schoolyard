class Directories < Application

  before :find_school
  before :selected_tab
  before :classrooms
  layout 'directory'
   
  def index
    if params[:label] == "classes"
      @class = @current_school.classrooms.find(params[:id])
      @students = @current_school.students.paginate(:all, :joins => :studies, :conditions => ["studies.classroom_id = ? and activate = ?", @class.id, true], :per_page => 25,  :page => params[:page] )
      @test = params[:id]
    else
      @students = @current_school.students.paginate(:all, :conditions => ['activate = ?', true], :per_page => 25,  :page => params[:page])
      @test = "All Students"
    end
     @selected = "current_students"
     render 
  end
  
  def letters
    if params[:ref] == "students"
       if params[:type] == "all"
          @students = @current_school.students.paginate(:all, :conditions => ['activate = ?', true], :per_page => 25,  :page => params[:page])
       else
          @students = @current_school.students.paginate(:all, :conditions => ['last_name LIKE ? and activate = ?',"#{params[:type]}%", true ], :per_page => 25,  :page => params[:page] )
       end
       @selected = "current_students"
    else  
       if params[:type] == "all"
         @staff = @current_school.staff.paginate(:all, :per_page => 25,  :page => params[:page])
       else
         @staff = @current_school.staff.paginate(:all, :conditions => ['last_name LIKE ?',"#{params[:type]}%" ], :per_page => 25,  :page => params[:page] )
       end
       @selected = "school_staff"
    end
     @s = params[:type].to_s
     render
  end
  
  def staff
    if params[:label] == "classes"
      @classroom = @current_school.classrooms.find(params[:id])
      @class_peoples = @classroom.class_peoples.delete_if{ |x| x.team_id != nil }
      @test = params[:id]
    else
      @staff = @current_school.staff.paginate(:all, :per_page => 25,  :page => params[:page])
      @test = "All Staff"
    end
    @selected = "school_staff"
    render 
  end
  
  
  def show
    if params[:label] == "students"
      @selected = "current_students"
      @student = @current_school.students.find_by_id(params[:id])
      raise NotFound unless @student
      @parents = @student.parents
      @protectors = @student.protectors
    elsif params[:label] == "staff"
      @selected = "school_staff"
      @staff = @current_school.staff.find(params[:id])
    else
      raise NotFound
    end
     render 
  end
  
  
  def generate_csv
    if params[:label] == "staff"
      @staff = @current_school.staff.find(:all)
      csv_string = FasterCSV.generate do |csv|
        csv << ["First Name", "Last Name", "Role", "E-mail", "Contact-Number"]
        @staff.each do |person|
          s = person.class_peoples
          s.each do |f|
            csv << [person.first_name, person.last_name, f.role.titleize+"--"+f.classroom.class_name, person.email, person.phone]
          end
          csv << [person.first_name, person.last_name, nil, person.email, person.phone]
        end
      end
      filename = params[:label] + ".csv"
      send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
    else
        @students = @current_school.students.find(:all, :conditions => ['activate = ?', true])
        csv_string = FasterCSV.generate do |csv|
          csv << ["First Name", "Last Name", "Address", "Contact-Number"]
          @students.each do |person|
            csv << [person.first_name, person.last_name, person.address, person.phone]
          end
        end
        filename = params[:label] + ".csv"
        send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
    end
  end
  
  private
  
  def selected_tab
     @select = "directory"
  end
  
  def classrooms
    @class_rooms = @current_school.active_classrooms
  end
  
  
end
