class Forms < Application

  layout 'wide'
  before :find_school
  before :access_rights, :exclude => [:form_files]
  before :forms, :only => [:index]
  before :classrooms


  def index
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
    if @form.update_attributes(params[:form])
       if params[:form][:attachment] == ""
          flash[:error] = "please upload a file"
          render :edit
       else
          create_attachments
          redirect url(:form_files, :l => "all_forms", :label => "forms")
       end
    else
       render :edit
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
       redirect url(:form_files, :l => "all_forms", :label => "forms")
    end
  end


  def form_files
     @classes = @current_school.active_classrooms
     @select = "forms"
     @selected = "all_forms"
     unless params[:id].nil?
       @class = @current_school.classrooms.find_by_id(params[:id])
       raise NotFound unless @class
       f = @current_school.forms.find(:all, :conditions => ['class_name = ?', @class.class_name])
       @forms = f.concat(@all_class_forms).sort_by{|my_item| my_item[:created_at]}.uniq
       @selected = @class.class_name
       @test = params[:id]
       @selected = "all_forms"
     end
     if params[:l] == "all_forms"
        f = @current_school.forms.find(:all)
        @forms = f.concat(@all_class_forms).sort_by{|my_item| my_item[:created_at]}.uniq
     end
     render :layout => 'directory'
  end
  
  def create_attachments
     @attachment = Attachment.create( :attachable_type => "Form",
                                      :attachable_id => @form.id,
                                      :filename => params[:form][:attachment][:filename],
                                      :content_type => params[:form][:attachment][:content_type],
                                      :size => params[:form][:attachment][:size],
                                      :school_id =>  @current_school.id
                                     )
     File.makedirs("public/uploads/#{@current_school.id}/files")
     FileUtils.mv( params[:form][:attachment][:tempfile].path, "public/uploads/#{@current_school.id}/files/#{@attachment.id}")
  end
  
  private

  def forms
    @classes = @current_school.active_classrooms
  end

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
