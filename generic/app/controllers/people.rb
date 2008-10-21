class People < Application
	
       
  def index
     @people = Person.find(:all)
     render
  end
  
  def new
     @person = Person.new
     @accesses = Access.find(:all)
     @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
     puts @access_view.inspect
     render
  end
  
  def create
     @accesses = Access.find(:all)
     @person = Staff.new(params[:person])
    if params[:access].nil?
       flash[:error]  = "You should check one of the checkboxes"
       render :new
    else
       if @person.save
	  @access = params[:access][:access_ids]
          @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
          @access_view_all = AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
           if params[:select_all] == "Select all"
	      AccessPeople.create({:person_id => @person.id, :all => true})
           else
	      @access.each do |f|
                @access_people = AccessPeople.create({:person_id => @person.id, :access_id => f })
              end
           end
          redirect url(:people)
       else
	  render :new
       end
    end
  end
  
  def edit
      @person = Person.find(params[:id]) 
      @accesses = Access.find(:all)
      @access_people = @person.access_peoples
      puts @access_people.inspect
      render
  end
  
  def update
      @person = Person.find(params[:id])
      @accesses = Access.find(:all)
      @access_people = @person.access_peoples
      puts "deep"
      puts params[:access].inspect
     # raise "Eshwar".inspect
   if params[:access].nil?
      flash[:error]  = "You should check one of the checkboxes"
      render :edit
   else
      if @person.update_attributes(params[:person])   
         @a = Access.find(:all)
         @acc = @a.delete_if{|x| x.name == "view_all"}
         @acc = @a.collect{|x| x.id}
         @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
         @access = params[:access][:access_ids]
         @access_peoples = @person.access_peoples
         @access_all = @access_peoples.collect{|x| x.all}
         @access_id = @access_peoples.collect{ |x| x.id }
         @access_people_id = @access_peoples.collect{|x| x.access_id}
            if @acc.length == @access.length
	       AccessPeople.destroy(@access_id)
	       AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
	       AccessPeople.create({:person_id => @person.id, :all => true})
            elsif (params[:select_all] == "Select all")
	       AccessPeople.destroy(@access_id)
	       AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
	       AccessPeople.create({:person_id => @person.id, :all => true})
            else
	       s = @access.zip(@access_id, @access_people_id)
	       AccessPeople.destroy(@access_id)
	       AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
	       s.each do |l|
		   if l[1].nil?
		      AccessPeople.create({:person_id => @person.id, :access_id => l[0] })
		   elsif ((l[2].nil?) && l[1].nil?)
			AccessPeople.create({:person_id => @person.id, :access_id => l[0] })
		   else
			AccessPeople.create({:person_id => @person.id, :access_id => l[0]})
		   end		   
	       end
            end
	  redirect url(:people)
       else
	  render :edit  
       end  
      
    end
    
  end

  
  def disable
    # @person = Person.find(params[:id])
     # @acc = @current_user.access_peoples
      #@access = Access.find(:first, :conditions => ['name=?', "view_all"])
      #@acc.each do |f|
       #  if f.access_id == @access.id
	#    AccessPeople.delete(f)
	 #end
      #end
      redirect url(:people)
  end
  
end
