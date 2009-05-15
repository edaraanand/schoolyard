class Schools < Application

  layout 'default'
  before :ensure_authenticated
  before :find_school
  before :access_rights, :exclude => [:school_admin]
  before :selected_link, :exclude => [:school_admin]

  def index
    @school = @current_school
    render
  end

  def school_admin
    render
  end

  def new
    @school = School.new
    render
  end

  def create
    @school = School.new(params[:school])
    if @school.save
      redirect resource(:schools)
    else
      render :new
    end
  end

  def edit
    @school = School.find(params[:id])
    render
  end

  def update
    @school = School.find(params[:id])
    if @school.update_attributes(params[:school])
       redirect resource(:schools)
    else
       render :edit
    end
  end

  private

  def access_rights
    @selected = "school_profile"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('basic_settings')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @access_people.each do |f|
      have_access = (f.all == true) || (f.access_id == @ann.id)
      break if have_access
    end
    unless have_access
      redirect resource(:homes)
    end
  end


  def selected_link
    @selected = "school_profile"
  end

end
