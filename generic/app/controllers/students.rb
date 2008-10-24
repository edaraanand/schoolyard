class Students < Application

  def index 
     @students = Student.find(:all)
     render
  end
  
  def new
     @student = Student.new
     @class_rooms = Classroom.find(:all, :conditions => ['class_type=?', "Classes"])
     @parent = Parent.new
     render
  end
  
  def create
	 # raise params.inspect
     @class_rooms = Classroom.find(:all, :conditions => ['class_type=?', "Classes"])
     @student = Student.new(params[:student])
     @parent = Parent.new(params[:parent])
   
     if ( params[:f_name_parent2].nil? && params[:l_name_parent2].nil? && params[:email].nil? )
        if @student.valid?
	   if @parent.valid? 
	      @student.save
	      @parent.save
	      Guardian.create({:student_id => @student.id, :parent_id => @parent.id })
	      Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })
	      redirect resource(:students)
	   else
	      render :new
	   end
        else
	   render :new
	end
     else
	 #   params["f_name_parent#{i}"]
	  if f_name_parent2.nil?
		 flash[:error] = "P2 first Name1"
		 render :new
	    elsif l_name_parent2.nil?
		  flash[:error] = "P2 lastname"
		  render :new
	    elsif email_parent2.nil?
		  flash[:error] = "P2 email"
		  render :new
	  else
	     @p = Parent.create({:first_name => params["f_name_parent#{i}".to_sym], :last_name => params["l_name_parent#{i}".to_sym], :email => params["email_parent#{i}".to_sym], :phone => @parent.phone, :address => @parent.address })
	     Guardian.create({:student_id => @student.id, :parent_id => @p.id }) 
	  end
	  
	  unless (f_name_parent3 != nil || l_name_parent3 != nil || email_parent3 != nil)
	     if f_name_parent3 != nil
		 flash[:error] = "P3-FN"
		 render :new
	     elsif l_name_parent3.nil?
		  flash[:error] = "P3 lastname"
		  render :new
	     elsif email_parent3.nil?
		 flash[:error] = "P3- email"
		  render :new
	     else
	       @p = Parent.create({:first_name => params[:f_name_parent3], :last_name => params[:l_name_parent3], :email => params[:email_parent3], :phone => @parent.phone, :address => @parent.address })
	       Guardian.create({:student_id => @student.id, :parent_id => @p.id }) 
	     end
           end
		  
		  
	 [2,3,4].each do |i|
	         if (params["f_name_parent#{i}"].nil?) && params["l_name_parent#{i}"].nil?
		    flash[:error] = "dont u hAve pArents, enter the detAils" 
		    @fname = params["f_name_parent#{i}".to_sym]
	            @lname = params["l_name_parent#{i}".to_sym]
	            @mail = params["email_parent#{i}".to_sym]
		    render :new
	          else
		    if @student.valid?
                      if @parent.valid?
			puts "#{i}".inspect
			puts params["f_name_parent#{i}".to_sym].inspect
		        @student.save
	                @parent.save
	                Guardian.create({:student_id => @student.id, :parent_id => @parent.id })
	                Study.create({:student_id => @student.id, :classroom_id => params[:classroom_id] })	
		        @p = Parent.create({:first_name => params["f_name_parent#{i}".to_sym], :last_name => params["l_name_parent#{i}".to_sym], :email => params["email_parent#{i}".to_sym], :phone => @parent.phone, :address => @parent.address })
		        Guardian.create({:student_id => @student.id, :parent_id => @p.id })
		        redirect resource(:students)
		      else
			render :new
		      end
	           else
		     render :new
	           end
	        end
          end
      
    end  
       
  end
 
  def edit
     @student = Student.find(params[:id])
     @class_rooms = Classroom.find(:all)
     render
  end
  
  def update
    # @parent = Parent.new
     @class_rooms = Classroom.find(:all)
     @student = Student.find(params[:id])
     @study_id = Study.find_by_student_id(@student.id)
     @student.attributes = params[:student]
      phone = params[:parent][:phone]
      address = params[:parent][:address]
      parents = @student.parents
      parent_id =  parents.collect{|x| x.id }
      s = params[:parent][:first_name].zip(params[:parent][:last_name], params[:parent][:email], parent_id)
           s.each do |s|
              if s[3].nil?
	         @student.parents << @student.parents.build({:first_name => s[0], :last_name => s[1], :email => s[2], :phone => "#{phone}", :address => "#{address}" })
              else   
	      @p =  Parent.update(s[3],{:first_name => s[0], :last_name => s[1], :email => s[2], :phone => "#{phone}", :address => "#{address}" } )
	      end
           end
       if @student.valid? 
	   if @p.valid?
              @student.save
	      Study.update(@study_id.id, {:student_id => @student.id, :classroom_id => params[:classroom_id]})
	      redirect resource(:students)
           else
	      flash[:error1] = "Please enter the Parent details"
	      render :edit
           end
       else
          render :edit
       end
  end
  
  
   def preview
      @first = params[:student][:first_name]
      @last = params[:student][:last_name]
      first = params[:parent][:first_name]
      last = params[:parent][:last_name]
      email = params[:parent][:email]
      @parent = first.zip(last, email)
      render :layout => 'preview'
   end
  
  
  
end


