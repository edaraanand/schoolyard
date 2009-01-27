class HomeWorks < Application
  
  layout 'default'
  before :find_school
  before :access_rights, :exclude => [:show]
  before :classrooms, :exclude => [:delete, :preview]
  before :rooms, :only => [:index]
  
  def index
     if params[:classroom_id].nil?
        @h_works = @current_school.home_works.find(:all)
     elsif params[:classroom_id] == "All Home Works"
        @works = @current_school.home_works.find(:all)
     else
        @classroom = @current_school.classrooms.find_by_class_name(params[:classroom_id])
        @home_works = @classroom.home_works.find(:all, :conditions => ['school_id = ?', @current_school.id])
     end
       @error = "No Homeworks Yet"
     render
  end
  
  def new
    @home_work = HomeWork.new
    render
  end
  
  def create
    @classroom = @current_school.classrooms.find_by_class_name(params[:home_work][:classroom_id])
    @person = session.user
    @home_work = @person.home_works.build(params[:home_work])
    @home_work.classroom_id = @classroom.id
    @home_work.school_id = @current_school.id
    if @home_work.save
       unless params[:home_work][:attachment].empty?
           @attachment = Attachment.create( :attachable_type => "Homework",
                                        :attachable_id => @home_work.id,
                                        :filename => params[:home_work][:attachment][:filename],
                                        :content_type => params[:home_work][:attachment][:content_type],
                                        :size => params[:home_work][:attachment][:size]
            )
           File.makedirs("public/uploads/#{@attachment.id}")
           FileUtils.mv(params[:home_work][:attachment][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
        end
       redirect resource(:home_works)
    else
       render :new
    end
  end
  
  def edit
    @home_work = HomeWork.find(params[:id])
    render
  end
  
  def update
    @classroom = Classroom.find_by_class_name(params[:home_work][:classroom_id])
    @home_work = HomeWork.find(params[:id])
    if @home_work.update_attributes(params[:home_work])
       Attachment.delete_all(['attachable_id = ?', @home_work.id])
        unless params[:home_work][:attachment].empty?
            @attachment = Attachment.create( :attachable_type => "Homework",
                                        :attachable_id => @home_work.id,
                                        :filename => params[:home_work][:attachment][:filename],
                                        :content_type => params[:home_work][:attachment][:content_type],
                                        :size => params[:home_work][:attachment][:size]
              )
         end
       @home_work.classroom_id = @classroom.id
       @home_work.person_id = session.user.id
       @home_work.school_id = @current_school.id
       @home_work.save
       redirect resource(:home_works)
    else
	     render :edit
    end
  end
  
  def delete
     @home_work = HomeWork.find(params[:id])
     Attachment.delete_all(['attachable_id = ?', @home_work.id])
     @home_work.destroy
     redirect resource(:home_works)
  end
  
  def preview
    render :layout => 'preview'
  end
  
  def show
     @home_work = HomeWork.find(params[:id])
     @classroom = @home_work.classroom
     render :layout => 'class_change', :id => @classroom.id
  end
 
  def home_works_pdf
    if params[:label] == "single"
       @home_work = HomeWork.find(params[:id])
       pdf = pdf_prepare("single", @home_work)
       send_data(pdf.render, :filename => "#{@home_work.title}.pdf", :type => "application/pdf")
    else
       @classroom = Classroom.find(params[:id])
       @home_works = @classroom.home_works.find(:all, :conditions => ['school_id = ?', @current_school.id])
       pdf = pdf_prepare("multiple", @home_works)
       send_data(pdf.render, :filename => "Homework for #{@classroom.class_name}.pdf", :type => "application/pdf")
     end
  end
  
  
  private
  
  def classrooms
    @classrooms = @current_school.classrooms.find(:all)
  end
  
  
  def rooms
    classes = @current_school.classrooms.find(:all)
    room = classes.collect{|x| x.class_name }
    @classes = room.insert(0, "All Home Works")
  end
  
  def access_rights
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
  
  def pdf_prepare(value, homework)
      pdf = PDF::Writer.new
      pdf.select_font "Helvetica"
      pdf.text "#{@current_school.school_name}", :font_size => 40, :justification => :center
      if value == "multiple"
         @home_works.each do |homework|
              pdf.text "Title : #{homework.title}", :font_size => 10, :justification => :left
              pdf.text "Description : #{homework.content}", :font_size => 10, :justification => :left
              pdf.text "Due Date : #{homework.due_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
          end
          pdf
      else
          pdf.text "Title : #{@home_work.title}", :font_size => 10, :justification => :left
          pdf.text "Description : #{@home_work.content}", :font_size => 10, :justification => :left
          pdf.text "Due Date : #{@home_work.due_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
          pdf
      end
  end
  
end
