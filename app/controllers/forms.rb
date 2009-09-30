class Forms < Application

  layout 'wide'
  before :find_school
  before :access_rights, :exclude => [:form_files]
  before :classrooms


  def index
    @classes = @current_school.active_classrooms
    if params[:label] == "classes"
       @classroom = @current_school.classrooms.find_by_id(params[:id])
       f = @current_school.forms.find(:all, :conditions => ['class_name = ?', @classroom.class_name])
       @forms = f.concat(@all_class_forms).sort_by{|my_item| my_item[:created_at]}.uniq
       @test = params[:id]
    else
       f = @current_school.forms.find(:all)
       @forms = f.concat(@all_class_forms).sort_by{|my_item| my_item[:created_at]}.uniq
       @test = "All Forms"
    end
    render
  end

  def new
    @form = Form.new
    render
  end

  def create
    @form = @current_school.forms.new(params[:form])
    i=0
    if @form.valid?
       unless params[:attachment]['file_'+i.to_s].empty?
          @form.save!
          Attachment.file(params.merge(:school_id => @current_school.id), "Form", @form.id)
          redirect resource(:forms)
       else
          flash[:error] = "please upload a file"
          @class_name = params[:form][:class_name]
          render :new
       end
    else
      @class_name = params[:form][:class_name]
      render :new
    end
  end

  def edit
    @form = @current_school.forms.find_by_id(params[:id]) rescue NotFound
    @attachment = @current_school.attachments.find_by_attachable_type_and_attachable_id("Form", @form.id)
    render
  end

  def update
    @form = @current_school.forms.find_by_id(params[:id])
    @attachment = @current_school.attachments.find_by_attachable_type_and_attachable_id("Form", @form.id)
    i=0
    if params[:attachment]
       if @form.update_attributes(params[:form])
          unless params[:attachment]['file_'+i.to_s].empty?
             @form.save!
             Attachment.file(params.merge(:school_id => @current_school.id), "Form", @form.id)
             redirect resource(:forms)
          else
             flash[:error] = "please upload a file"
             @class_name = params[:form][:class_name]
             render :edit
          end
       else
          render :edit
       end
    else
       if @form.update_attributes(params[:form])
          redirect resource(:forms)
       else
          render :edit
       end
    end
  end
  
  def delete
    if params[:label] == "attachment"
       attach = @current_school.attachments.find_by_id(params[:id]) rescue NotFound
       @form = @current_school.forms.find_by_id(attach.attachable_id)
       attach.destroy
       @attachment = @current_school.attachments.find_by_attachable_type_and_attachable_id("Form", @form.id)
       render :edit, :id => @form.id
    else
       @form = @current_school.forms.find_by_id(params[:id]) rescue NotFound
       Attachment.delete_all(['attachable_id = ?', @form.id])
       @form.destroy
       redirect url(:form_files, :ref => "forms")
    end
  end


  def form_files
     @classes = @current_school.active_classrooms
     @select = @selected = "forms"
     if params[:id]
        @class = @current_school.classrooms.find_by_id(params[:id]) rescue NotFound
        f = @current_school.forms.find(:all, :conditions => ['class_name = ?', @class.class_name])
        @forms = f.concat(@all_class_forms).sort_by{|my_item| my_item[:created_at]}.uniq
        @test = params[:id]
     else
        f = @current_school.forms.find(:all)
        @forms = f.concat(@all_class_forms).sort_by{|my_item| my_item[:created_at]}.uniq
     end
     render :layout => 'form'
  end
  
  private

  def classrooms
    classes = @current_school.active_classrooms
    room = classes.collect{|x| x.class_name }
    @classrooms = room.insert(0, "All Classes")
    @all_class_forms = Form.all_forms(@current_school.id)
  end


  def access_rights
    @selected = "forms"
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
