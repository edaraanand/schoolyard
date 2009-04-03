class Forms < Application
  
  layout 'default'
  before :find_school
  before :classrooms
  before :access_rights, :exclude => [:form_files]
  before :forms, :only => [:index]
 
    
  def index
    if params[:class_name].nil?
      @forms = @current_school.forms.paginate(:all, :per_page => 5, :page => params[:page])
    end
    if params[:class_name] == "All Forms"
      @forms_f = @current_school.forms.paginate(:all, :per_page => 5, :page => params[:page])
    end
    @files = @current_school.forms.paginate(:all, :conditions => ['class_name = ?', params[:class_name] ], :per_page => 5, :page => params[:page] )
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
        unless params[:attachment]['file_'+i.to_s].empty?
            @form.save
            @attachment = Attachment.create( :attachable_type => "Form",
                                        :attachable_id => @form.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
             )
              File.makedirs("public/uploads/#{@attachment.id}")
              FileUtils.mv(params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
              redirect resource(:forms)
        else
            flash[:error] = "please upload a File"
            render :new
        end
     else
        render :new
     end
  end
   
  def edit
     @form = Form.find(params[:id])
     @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type = ?", @form.id, "Form"])
     @allowed = 1 - @attachments.size
     render
  end
  
  def update
     @form = Form.find(params[:id])
     @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type = ?", @form.id, "Form"])
     @allowed = 1 - @attachments.size
     i=0
     if params[:attachment]
        if @form.update_attributes(params[:form])
            unless params[:attachment]['file_'+i.to_s].empty?
                @attachment = Attachment.create( :attachable_type => "Form",
                                        :attachable_id => @form.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
                )
                  File.makedirs("public/uploads/#{@attachment.id}")
                  FileUtils.mv(params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
                  redirect resource(:forms)
             else
                 flash[:error] = "please upload a File"
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
        @attachment = Attachment.find(params[:id])
        @form = Form.find_by_id(@attachment.attachable_id)
        @attachment.destroy
        @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type = ?", @form.id, "Form"])
        @allowed = 1 - @attachments.size
        render :edit, :id => @form.id
     else
        @form = Form.find(params[:id])
        Attachment.delete_all(['attachable_id = ?', @form.id])
        @form.destroy
        redirect resource(:forms)
     end
  end
  
  
  def form_files
     @select = "forms"
     @selected = "all_forms"
     unless params[:id].nil?
         @class = @current_school.classrooms.find(params[:id])
         @forms = @current_school.forms.paginate(:all, :conditions => ["class_name = ?", @class.class_name ], :per_page => 5, :page => params[:page] )
         @selected = @class.class_name 
     end
     if params[:l] == "all_forms"
       @all_forms = @current_school.forms.paginate(:all, :per_page => 5, :page => params[:page])
     end
     render :layout => 'directory'
  end
 
  
  private
  
  def forms
     @class = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
     room = @class.collect{|x| x.class_name.titleize }
     @classrooms = room.insert(0, "All Forms")
  end
  
  def classrooms
    classes = @current_school.classrooms.find(:all, :conditions => ['activate = ?', true])
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
