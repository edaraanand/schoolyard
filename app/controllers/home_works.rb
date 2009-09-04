class HomeWorks < Application
  
  layout 'default'
  before :find_school
  before :access_rights, :exclude => [:class_works, :home_works_pdf]
  before :classrooms, :exclude => [:preview]
  before :rooms, :only => [:index]

  def index
    if params[:label] == "classes"
       @classroom = @current_school.classrooms.find_by_id(params[:id], :conditions => ['activate = ?', true])
       @home_works = @classroom.home_works.paginate(:all, :conditions => ['school_id = ?', @current_school.id], :order => "due_date ASC", :per_page => 10, :page => params[:page])
       @test = params[:id]
    else
       @home_works = @current_school.home_works.paginate(:all, :order => "due_date ASC", :per_page => 10, :page => params[:page])
       @test = "All Homeworks"
    end
    render
  end

  def new
    @home_work = HomeWork.new
    render
  end

  def create
     @person = session.user
     @home_work = @person.home_works.new(params[:home_work])
     i=0
     if @home_work.valid?
        @classroom = @current_school.classrooms.find_by_class_name(params[:home_work][:classroom_id])
        @home_work.classroom_id = @classroom.id
        @home_work.school_id = @current_school.id
        @home_work.save
        unless params[:attachment]['file_'+i.to_s].empty?
          type = "Homework"
          Attachment.file(params.merge(:school_id => @current_school.id), type, @home_work.id)
        end
        run_later do
           email_alerts(@home_work.classroom_id, self.class, @home_work, @current_school)
        end
        redirect  url(:class_details, :id => @classroom.id, :label => "homeworks")
     else
       @date = params[:home_work][:due_date]
       @class_id =  params[:home_work][:classroom_id]
       render :new
     end
  end
  
  def edit
    @home_work = @current_school.home_works.find(params[:id])
    @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @home_work.id, "Homework"])
    @allowed = 1 - @attachments.size
    render
  end

  def update
     @classroom = @current_school.classrooms.find_by_class_name(params[:home_work][:classroom_id])
     @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @home_work.id, "Homework"])
     @allowed = 1 - @attachments.size
     @home_work = @current_school.home_works.find(params[:id])
     i=0
     if @home_work.update_attributes(params[:home_work])
        @home_work.classroom_id = @classroom.id
        @home_work.person_id = session.user.id
        @home_work.school_id = @current_school.id
        @home_work.save
        if params[:attachment]
           unless params[:attachment]['file_'+i.to_s].empty?
              type = "Homework"
              Attachment.file(params.merge(:school_id => @current_school.id), type, @home_work.id)
           end
        end
        redirect  url(:class_details, :id => @classroom.id, :label => "homeworks")
     else
        @class_id =  params[:home_work][:classroom_id]
        render :edit
     end
  end
   
  def delete
    if params[:label] == "attachment"
      @attachment = @current_school.attachments.find(params[:id])
      @home_work = @current_school.home_works.find_by_id(@attachment.attachable_id)
      @attachment.destroy
      @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @home_work.id, "Homework"])
      @allowed = 1 - @attachments.size
      render :edit, :id => @home_work.id
    else
      @home_work = @current_school.home_works.find(params[:id])
      @classroom = @home_work.classroom
      Attachment.delete_all(['attachable_id = ?', @home_work.id])
      @home_work.destroy
      redirect  url(:class_details, :id => @classroom.id, :label => "homeworks")
    end
  end

  def preview
    @date = Date.today
    @select = "classrooms"
    @selected = "homeworks"
    @classroom = @current_school.classrooms.find_by_class_name(params[:home_work][:classroom_id])
    render :layout => 'class_change', :id => @classroom.id
  end

  def show
    @selected = "home_work"
    @home_work = @current_school.home_works.find(params[:id])
    render :layout => 'default'
  end

  def class_works
    @selected = "homeworks"
    @select = "classrooms"
    @home_work = @current_school.home_works.find(params[:id])
    @classroom = @home_work.classroom
    render :layout => 'class_change', :id => @classroom.id
  end
  
  def send_alerts(home_work)
    @home_work = home_work
    @alert = Alert.find(:first, :conditions => ['name = ?', "home_work_message"])
    @people = @current_school.people.find(:all)
    @people.each do |p|
      alerts = AlertPeople.find(:all, :conditions=>["person_id=? and classroom_id=? and alert_id = ?", p.id, @home_work.classroom_id, @alert.id])
      unless alerts.empty?
        raise p.inspect
      end
    end
  end
  
  def home_works_pdf
    if params[:label] == "single"
      @home_work = @current_school.home_works.find(params[:id])
      pdf = pdf_prepare("single", @home_work)
      send_data(pdf.render, :filename => "#{@home_work.title}.pdf", :type => "application/pdf")
    else
      @classroom = @current_school.classrooms.find(params[:id])
      @home_works = @classroom.home_works.find(:all, :conditions => ['school_id = ?', @current_school.id], :order => "due_date ASC")
      pdf = pdf_prepare("multiple", @home_works)
      send_data(pdf.render, :filename => "Homework for #{@classroom.class_name}.pdf", :type => "application/pdf")
    end
  end


  private

  def classrooms
    @classrooms = @current_school.classes
  end


  def rooms
    @classes = @current_school.classes
  end

  def access_rights
    @selected = "home_work"
    have_access = false
    @view = Access.find_by_name('view_all')
    @ann = Access.find_by_name('homework')
    @access_people = session.user.access_peoples.delete_if{|x| x.access_id == @view.id }
    @access_people.each do |f|
      have_access = (f.all == true) || (f.access_id == @ann.id)
      break if have_access
    end
    unless have_access
      redirect resource(:homes)
    end
  end
  
  def format(str)
    the_str = str.to_s
    the_str = the_str.gsub(/[^a-zA-Z0-9-]/, " ")
    the_str
  end

  def pdf_prepare(value, homework)
    pdf = PDF::Writer.new
    pdf.select_font "Times-Roman"
    pdf.text "#{@current_school.school_name}", :font_size => 20, :justification => :center
    if value == "multiple"
      @home_works.each do |homework|
        con = san_content(homework.content)
        con = con.gsub("”", "") 
        con = con.gsub("“", "")
        con = con.gsub("’", "")
        con = con.gsub("‘", "")
        con = con.gsub("’", "")
        con = con.gsub("– ", "")
        con = con.gsub(/[^a-zA-Z0-9-]/, " ")
        pdf.text "<b>Due Date</b>" + ":" + "" + "#{homework.due_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left, :spacing => 2
        pdf.text "<b>Title</b>" + ":" + "" + "#{homework.title}", :font_size => 10, :justification => :left
        pdf.text "<b>Description</b>" + ":" + "" 
        con.split('br').map do |c| 
          pdf.text c, :font_size => 10, :justification => :left
        end
      end
      pdf
    else
      con = san_content(@home_work.content)
      con = con.gsub("”", "") 
      con = con.gsub("“", "")
      con = con.gsub("’", "")
      con = con.gsub("‘", "")
      con = con.gsub("’", "")
      con = con.gsub("– ", "")
      con = con.gsub(/[^a-zA-Z0-9-]/, " ")
      pdf.text "<b>Due Date</b>" + ":" + "" + "#{@home_work.due_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
      pdf.text "<b>Title</b>" + ":" + "" + "#{@home_work.title}", :font_size => 10, :justification => :left
      pdf.text "<b>Description</b>" + ":" + "" 
      con.split('br').map do |c| 
        pdf.text c, :font_size => 10, :justification => :left
      end
      pdf
    end
  end


end
