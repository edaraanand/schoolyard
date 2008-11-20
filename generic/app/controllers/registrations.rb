class Registrations < Application

  before :month_year
  
  def index
    render
  end
  
  def new
    @parent = Parent.new
    @student = Student.new
    render
  end
  
  def create
    @parent = Parent.new(params[:parent])
    @student = Student.new(params[:student])
   # raise "Goutham".inspect
   if (params[:f_name_student2] == "") && (params[:l_name_student2] == "") 
        if (@parent.valid?) && (@student.valid?)
          if (params[:classroom_id] == "") 
              flash[:error] = "Please select the Classroom"
              render :new
           else
              puts "Eshwar".inspect
              raise params.inspect
           end
        else
           render :new
        end
      else
        if (@parent.valid?) && (@student.valid?)
          if ( ( ( (params[:f_name_student2] != "") && (params[:l_name_student2] != "") ) &&  ( (params[:classroom_id2] != "") &&  (params[:month2] != "") ) ) ) && (params[:year2] != "")
         # if ( ( (params[:f_name_student2] != "") && (params[:l_name_student2] != "") ) && (params[:classroom_id2] != "") )
        # raise "Naidu".inspect 
         #if ( ( ( (params[:f_name_student3] != "") || (params[:l_name_student3] != "") ) ||  ( (params[:classroom_id3] != "") ||  (params[:month3] != "") ) ) ) || (params[:year3] != "")
              if ( ( (params[:f_name_student3] != "") || (params[:l_name_student3] != "") ) || (params[:classroom_id3] != "") )
                  if ( ( (params[:f_name_student4] !="") || (params[:l_name_student4] != "") ) || (params[:classroom_id4] != "") )
                    if ( ( ( (params[:f_name_student4] != "") && (params[:l_name_student4] != "") ) &&  ( (params[:classroom_id4] != "") &&  (params[:month4] != "") ) ) ) && (params[:year4] != "")
                      #if ( ( (params[:f_name_student4] != "") && (params[:l_name_student4] != "") ) && (params[:classroom_id4] != "") )
                         
                              puts "Eshwar".inspect
                              raise "Eshwar".inspect
                      else
                         flash[:error4] = "Please enter the Student4 details"
                         @fname4 = params[:f_name_student4]
	                       @lname4 = params[:l_name_student4]
	                       @classroom_id4 = params[:classroom_id4]
                         @year4 = params[:year4]
                         @month4 = params[:month4]
	                       @fname3 = params[:f_name_student3]
	                       @lname3 = params[:l_name_student3]
	                       @classroom_id3 = params[:classroom_id3]
                         @year3 = params[:year3]
                         @month3 = params[:month3]
                         @fname2 = params[:f_name_student2]
	                       @lname2 = params[:l_name_student2]
	                       @classroom_id2 = params[:classroom_id2]
                         @year2 = params[:year2]
                         @month2 = params[:month2]
		                     render :new 
                      end
                 else
                    if ( ( ( (params[:f_name_student3] != "") && (params[:l_name_student3] != "") ) &&  ( (params[:classroom_id3] != "") &&  (params[:month3] != "") ) ) ) && (params[:year3] != "")
                    # if( ( (params[:f_name_student3] != "") && (params[:l_name_student3] != "") ) && (params[:classroom_id3] != "") )
                          puts "Raja".inspect
                          raise "Raja".inspect
                     else
                          flash[:error3] = "Please enter the Student3 details"
	                        @fname3 = params[:f_name_student3]
	                        @lname3 = params[:l_name_student3]
	                        @classroom_id3 = params[:classroom_id3]
                          @year3 = params[:year3]
                          @month3 = params[:month3]
                          @fname2 = params[:f_name_student2]
	                        @lname2 = params[:l_name_student2]
	                        @classroom_id2 = params[:classroom_id2]
                          @year2 = params[:year2]
                          @month2 = params[:month2]
                          render :new
                     end
                 end
             else
                 puts "Gouthama".inspect
                 raise "Gouthama".inspect
             end
          else
              flash[:error] = "Please enter the Student2 details"
	            @fname2 = params[:f_name_student2]
	            @lname2 = params[:l_name_student2]
	            @classroom_id2 = params[:classroom_id2]
             # @classroom_id2 =  Classroom.find_by_id(params[:classroom_id2])
              puts @classroom_id2.inspect
                @year2 = params[:year2]
                @month2 = params[:month2]
              render :new
          end  
      else
         render :new
      end
      
    end
  end
  
  
  private
  
  def month_year
    @classrooms = Classroom.find(:all)
    @years = (1999..2020).to_a 
    @months = [ 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
  end
  
end
