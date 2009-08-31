class Forms < Application

  layout 'wide'
  before :find_school
  before :classrooms
  before :access_rights, :exclude => [:form_files]
  before :forms, :only => [:index]


  def index
    if params[:label] == "classes"
      @classroom = @current_school.classrooms.find_by_id(params[:id])
      @forms = @current_school.forms.paginate(:all, :conditions => ['class_name = ?', @classroom.class_name], :per_page => 25,  :page => params[:page] )
      @test = params[:id]
    else
      @forms = @current_school.forms.paginate(:all, :per_page => 25,  :page => params[:page])
      @test = "All Forms"
    end
    render
  end

  def new
    @form = Form.new
    @attachment = Attachment.new
    render
  end

  def create
    @form = @current_school.forms.new(params[:form])
    i=0
    if @form.valid?
      if ( (params[:form][:class_name] != "") && (params[:form][:year] != "") )
        unless params[:attachment]['file_'+i.to_s].empty?
          @form.save
          @attachment = Attachment.create( :attachable_type => "Form",
          :attachable_id => @form.id,
          :filename => params[:attachment]['file_'+i.to_s][:filename],
          :content_type => params[:attachment]['file_'+i.to_s][:content_type],
          :size => params[:attachment]['file_'+i.to_s][:size],
          :school_id =>  @current_school.id
          )
          File.makedirs("public/uploads/#{@current_school.id}/files")
          FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@current_school.id}/files/#{@attachment.id}")
          redirect url(:form_files, :l => "all_forms", :label => "forms")
        else
          flash[:error] = "please upload a File"
          @c = params[:form][:class_name]
          @y = params[:form][:year]
          render :new
        end
      else
        flash[:error] = "Please select classroom and year"
        @c = params[:form][:class_name]
        @y = params[:form][:year]
        render :new
      end
    else
      @c = params[:form][:class_name]
      @y = params[:form][:year]
      render :new
    end

  end

  def edit
    @form = @current_school.forms.find(params[:id])
    @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type = ?", @form.id, "Form"])
    @allowed = 1 - @attachments.size
    render
  end

  def update
    @form = @current_school.forms.find(params[:id])
    @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type = ?", @form.id, "Form"])
    @allowed = 1 - @attachments.size
    i=0
    if params[:attachment]
      if ( (params[:form][:class_name] != "") && (params[:form][:year] != "") )
        if @form.update_attributes(params[:form])
          unless params[:attachment]['file_'+i.to_s].empty?
            @attachment = Attachment.create( :attachable_type => "Form",
            :attachable_id => @form.id,
            :filename => params[:attachment]['file_'+i.to_s][:filename],
            :content_type => params[:attachment]['file_'+i.to_s][:content_type],
            :size => params[:attachment]['file_'+i.to_s][:size],
            :school_id =>  @current_school.id
            )
            File.makedirs("public/uploads/#{@current_school.id}/files")
            FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@current_school.id}/files/#{@attachment.id}")
            redirect url(:form_files, :l => "all_forms", :label => "forms")
          else
            flash[:error] = "please upload a File"
            render :edit
          end
        else
          render :edit
        end
      else
        flash[:error] = "Please select classroom and year"
        render :edit
      end
    else
      if ( (params[:form][:class_name] != "") && (params[:form][:year] != "") )
        if @form.update_attributes(params[:form])
           redirect url(:form_files, :l => "all_forms", :label => "forms")
        else
          render :edit
        end
      else
        flash[:error] = "Please select classroom and year"
        render :edit
      end
    end
  end

  def delete
    if params[:label] == "attachment"
      @attachment = @current_school.attachments.find(params[:id])
      @form = @current_school.forms.find_by_id(@attachment.attachable_id)
      @attachment.destroy
      @attachments = @current_school.attachments.find(:all, :conditions => ["attachable_id = ? and attachable_type = ?", @form.id, "Form"])
      @allowed = 1 - @attachments.size
      render :edit, :id => @form.id
    else
      @form = @current_school.forms.find(params[:id])
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
      @forms = @current_school.forms.paginate(:all, :conditions => ["class_name = ?", @class.class_name ], :per_page => 25,  :page => params[:page] )
      @selected = @class.class_name
      @test = params[:id]
      @selected = "all_forms"
    end
    if params[:l] == "all_forms"
      @all_forms = @current_school.forms.paginate(:all, :per_page => 25,  :page => params[:page])
    end
    render :layout => 'directory'
  end


  private

  def forms
    @classes = @current_school.active_classrooms
  end

  def classrooms
    classes = @current_school.active_classrooms
    room = classes.collect{|x| x.class_name.titleize }
    @classrooms = room.insert(0, "All Classes")
    @years = (2009..2025).to_a
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