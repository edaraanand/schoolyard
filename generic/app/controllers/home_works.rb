class HomeWorks < Application
  
  layout 'default'
  before :find_school
  before :access_rights, :exclude => [:show]
  before :classrooms, :exclude => [:preview]
  before :rooms, :only => [:index]
  
  def index
     if params[:classroom_id].nil?
       @h_works = @current_school.home_works.paginate(:all, :order => "due_date DESC", :per_page => 3, :page => params[:page])
     elsif params[:classroom_id] == "All Homework"
        @works = @current_school.home_works.paginate(:all, :order => "due_date DESC", :per_page => 3, :page => params[:page])
     else
        @classroom = @current_school.classrooms.find_by_class_name(params[:classroom_id])
        @home_works = @classroom.home_works.paginate(:all, :conditions => ['school_id = ?', @current_school.id], :order => "due_date DESC", :per_page => 3, :page => params[:page])
     end
       @error = "There are no Homeworks at this time."
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
    i=0
    if @home_work.valid?
       @home_work.save
        unless params[:attachment]['file_'+i.to_s].empty?
           @attachment = Attachment.create( :attachable_type => "Homework",
                                        :attachable_id => @home_work.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
            )
           File.makedirs("public/uploads/#{@attachment.id}")
           FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
        end
       redirect resource(:home_works)
    else
       render :new
    end
  end
  
  def edit
    @home_work = HomeWork.find(params[:id])
    @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @home_work.id, "Homework"])
    @allowed = 1 - @attachments.size
    render
  end
  
  def update
    @classroom = Classroom.find_by_class_name(params[:home_work][:classroom_id])
    @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @home_work.id, "Homework"])
    @allowed = 1 - @attachments.size
    @home_work = HomeWork.find(params[:id])
    i=0
    if params[:attachment]
        if@home_work.update_attributes(params[:home_work])
            unless params[:attachment]['file_'+i.to_s].empty?
              @attachment = Attachment.create( :attachable_type => "Homework",
                                        :attachable_id => @home_work.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
                )
                  File.makedirs("public/uploads/#{@attachment.id}")
                  FileUtils.mv(params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
             end
             @home_work.classroom_id = @classroom.id
             @home_work.person_id = session.user.id
             @home_work.school_id = @current_school.id
             @home_work.save
             redirect resource(:home_works)
        else
             render :edit
        end
    else
         if @home_work.update_attributes(params[:home_work])
            @home_work.classroom_id = @classroom.id
            @home_work.person_id = session.user.id
            @home_work.school_id = @current_school.id
            @home_work.save
            redirect resource(:home_works)
         else
            render :edit
         end
    end
  end
  
  def delete
     if params[:label] == "attachment"
        @attachment = Attachment.find(params[:id])
        @home_work = HomeWork.find_by_id(@attachment.attachable_id)
        @attachment.destroy
        @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @home_work.id, "Homework"])
        @allowed = 1 - @attachments.size
        render :edit, :id => @home_work.id
     else
        @home_work = HomeWork.find(params[:id])
        Attachment.delete_all(['attachable_id = ?', @home_work.id])
        @home_work.destroy
        redirect resource(:home_works)
     end
  end
  
  def preview
    render :layout => 'preview'
  end
  
  def show
     if params[:label] == "home_w"
        @selected = "home_work"
        @home_work = HomeWork.find(params[:id])
        render :layout => 'default'
     else
         @selected = "homeworks"
         @select = "classrooms"
         @home_work = HomeWork.find(params[:id])
         @classroom = @home_work.classroom
         render :layout => 'class_change', :id => @classroom.id
     end
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
    @classrooms = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
  end
  
  
  def rooms
    classes = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
    room = classes.collect{|x| x.class_name.titleize }
    @classes = room.insert(0, "All Homework")
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
  
  def pdf_prepare(value, homework)
      pdf = PDF::Writer.new
      pdf.select_font "Helvetica"
      pdf.text "#{@current_school.school_name}", :font_size => 20, :justification => :center
      if value == "multiple"
         @home_works.each do |homework|
              pdf.text "<b>Title</b>" + ":" + "" + "#{homework.title}", :font_size => 10, :justification => :left
              pdf.text "<b>Description</b>" + ":" + "" + "#{homework.content}", :font_size => 10, :justification => :left
              pdf.text "<b>Due Date</b>" + ":" + "" + "#{homework.due_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
          end
          pdf
      else
          pdf.text "<b>Title</b>" + ":" + "" + "#{@home_work.title}", :font_size => 10, :justification => :left
          pdf.text "<b>Description</b>" + ":" + "" + "#{@home_work.content}", :font_size => 10, :justification => :left
          pdf.text "<b>Due Date</b>" + ":" + "" + "#{@home_work.due_date.strftime("%B %d %Y")}", :font_size => 10, :justification => :left
          pdf
      end
  end
  

end
