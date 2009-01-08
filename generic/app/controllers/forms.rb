class Forms < Application
  
  layout 'default'
  
  before :classrooms
  before :access_rights, :exclude => [:form_files]
  before :forms, :only => [:index]
  
  def index
    if params[:class_name].nil?
       @forms = Form.find(:all)
    end
    if params[:class_name] == "All Forms"
      @forms_f = Form.find(:all)
    end
    @files = Form.find(:all, :conditions => ['class_name = ?', params[:class_name] ] )
    render
  end
  
  def new
    @form = Form.new
    render
  end
  
  def create
     @form = Form.new(params[:form])
     if @form.save
       unless params[:form][:attachment].empty?
           @attachment = Attachment.create( :attachable_type => "Form",
                                        :attachable_id => @form.id,
                                        :filename => params[:form][:attachment][:filename],
                                        :content_type => params[:form][:attachment][:content_type],
                                        :size => params[:form][:attachment][:size]
           )
          File.makedirs("public/uploads/#{@attachment.id}")
          FileUtils.mv(params[:form][:attachment][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
       end
       redirect resource(:forms)
    else
      render :new
    end
  end
   
  def edit
    @form = Form.find(params[:id])
    render
  end
  
  def update
    @form = Form.find(params[:id])
    if @form.update_attributes(params[:form])
        Attachment.delete_all(['attachable_id = ?', @form.id])
        unless params[:form][:attachment].empty?
            @attachment = Attachment.create( :attachable_type => "Form",
                                        :attachable_id => @form.id,
                                        :filename => params[:form][:attachment][:filename],
                                        :content_type => params[:form][:attachment][:content_type],
                                        :size => params[:form][:attachment][:size]
             )
        end
       redirect resource(:forms)
    else
       render :edit
    end
    
  end
  
  def delete
     @form = Form.find(params[:id])
     Attachment.delete_all(['attachable_id = ?', @form.id])
     @form.destroy
     redirect resource(:forms)
  end
  
  def form_download
     @form = Form.find(params[:id])
     @attachment = Attachment.find(:first, :conditions => ['attachable_id=?', @form.id] )
     send_file("#{Merb.root}/public/uploads/#{@attachment.id}/#{@attachment.filename}") 
  end
  
  def form_files
     if params[:class_name].nil?
        @forms = Form.find(:all)
     end
     if params[:class_name] == "All Forms"
        @forms_f = Form.find(:all)
     end
     @files = Form.find(:all, :conditions => ['class_name = ?', params[:class_name] ] )
     render :layout => 'home'
  end
  
  
  private
  
  def forms
     @class = Classroom.find(:all)
     room = @class.collect{|x| x.class_name }
     @classrooms = room.insert(0, "All Forms")
  end
  
  def classrooms
    classes = Classroom.find(:all)
    room = classes.collect{|x| x.class_name }
    @classrooms = room.insert(0, "All Classes")
    @years = (1999..2025).to_a
  end
  
 
  def access_rights
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
