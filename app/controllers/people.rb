class People < Application

  layout 'default'
  before :access_rights
  before :titles
  before :find_school

  def index
    @people = @current_school.people.paginate(:all, :conditions => ['type = ?', "Staff"], :per_page => 25,  :page => params[:page])
    render
  end

  def new
    @person = Person.new
    @accesses = Access.find(:all).delete_if{|x| x.name == "view_all"}
    @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
    @p = @accesses.collect{|x| x.id.to_s}
    render
  end

  def create
    @accesses = Access.find(:all).delete_if{|x| x.name == "view_all"}
    @person = @current_school.people.new(params[:person])
    @p = @accesses.collect{|x| x.id.to_s}
    if @person.valid?
      @person.type = "Staff"
      @person.activate = true
      @person.save
      unless params[:access].nil?
        @access = params[:access][:access_ids]
      end
      @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
      @access_view_all = AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
      if params[:select_all] == "Select all"
        AccessPeople.create({:person_id => @person.id, :all => true})
      else
        unless params[:access].nil?
          @access.each do |f|
            @access_people = AccessPeople.create({:person_id => @person.id, :access_id => f })
          end
        end
      end
      run_later do
         @person.send_p
      end
      redirect url(:staff)
    else
      unless params[:access].nil?
        @access = params[:access][:access_ids]
        @accesses = Access.find(:all).delete_if{|x| x.name == "view_all"}
        @p = @accesses.collect{|x| x.id.to_s}
      end
      render :new
    end
  end

  def show
    @staff = @current_school.staff.find_by_id(params[:id])
    raise NotFound unless @staff
    render
  end
  
  def edit
    @person = @current_school.people.find_by_id(params[:id])
    raise NotFound unless @person
    @accesses = Access.find(:all).delete_if{|x| x.name == "view_all"}
    @access_people = @person.access_peoples
    render
  end

  def update
    @person = @current_school.people.find(params[:id])
    @accesses = Access.find(:all).delete_if{|x| x.name == "view_all"}
    @access_people = @person.access_peoples
    if @person.update_attributes(params[:person])
       @person.activate = true
       @person.save
      @a = Access.find(:all)
      @acc = @a.delete_if{|x| x.name == "view_all"}
      @acc = @a.collect{|x| x.id}
      @access_view = Access.find(:first, :conditions => ['name=?', "view_all"])
      unless params[:access].nil?
        @access = params[:access][:access_ids]
      end
      @access_peoples = @person.access_peoples
      @access_all = @access_peoples.collect{|x| x.all}
      @access_id = @access_peoples.collect{ |x| x.id }
      @access_people_id = @access_peoples.collect{|x| x.access_id}
      if (params[:select_all] == "Select all")
        AccessPeople.destroy(@access_id)
        AccessPeople.create({:person_id => @person.id, :access_id => @access_view.id})
        AccessPeople.create({:person_id => @person.id, :all => true})
      else
        unless params[:access].nil?
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
      end
      run_later do
         @person.changed_details
      end
      redirect url(:staff)
    else
      render :edit
    end

  end


  def disable
    @person = @current_school.people.find_by_id(params[:id])
    raise NotFound unless @person
    @person.activate = false
    @person.crypted_password = ""
    @person.password_reset_key = ""
    @person.save
    redirect url(:edit_person, @person.id)
  end

  def enable
    @person = @current_school.people.find_by_id(params[:id])
    raise NotFound unless @person
    @person.activate = true
    @person.save
    run_later do 
      @person.send_p
    end
    redirect url(:edit_person, @person.id)
  end

 
  private

  def access_rights
    @selected = "rights"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('rights_others')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @access_people.each do |f|
      have_access = (f.all == true) || (f.access_id == @ann.id)
      break if have_access
    end
    unless have_access
      redirect resource(:homes)
    end
  end

  def titles
    a = []
    t1 = a.insert(0, "Mr.")
    t2 = a.insert(1, "Mrs.")
    t3 = a.insert(2, "Ms.")
    @titles = a.insert(3, "Dr.")
  end


end
