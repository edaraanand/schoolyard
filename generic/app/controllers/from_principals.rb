class FromPrincipals < Application
  layout 'default'
  before :find_school

  def index
     @announcements = @current_school.announcements.find(:all, :conditions => ['label=?', "from_principal"])
     render
  end
  
  def new
     @announcement = Announcement.new
     render
  end
  
  def create
     @announcement = @current_school.announcements.new(params[:announcement])
     i=0
     if @announcement.valid?
        @announcement.label = "from_principal"
        @announcement.save
        unless params[:attachment]['file_'+i.to_s].empty?
           @attachment = Attachment.create( :attachable_type => "Announcement",
                                        :attachable_id => @announcement.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
            )
           File.makedirs("public/uploads/#{@attachment.id}")
           FileUtils.mv( params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
        end
        redirect resource(:from_principals)
     else
	      render :new
     end
  end

  def edit
     @announcement = Announcement.find(params[:id])
     @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
     @allowed = 1 - @attachments.count
     render
  end
  
  def update
     @announcement = Announcement.find(params[:id])
     @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
     @allowed = 1 - @attachments.count
     i=0
     if params[:attachment]
         if @announcement.update_attributes(params[:announcement])
            @announcement.label = "from_principal"
            @announcement.save
            unless params[:attachment]['file_'+i.to_s].empty?
              @attachment = Attachment.create( :attachable_type => "Announcement",
                                        :attachable_id => @announcement.id,
                                        :filename => params[:attachment]['file_'+i.to_s][:filename],
                                        :content_type => params[:attachment]['file_'+i.to_s][:content_type],
                                        :size => params[:attachment]['file_'+i.to_s][:size]
                )
                  File.makedirs("public/uploads/#{@attachment.id}")
                  FileUtils.mv(params[:attachment]['file_'+i.to_s][:tempfile].path, "public/uploads/#{@attachment.id}/#{@attachment.filename}")
             end
             redirect resource(:from_principals)
        else
            render :edit
        end
    else
         if @announcement.update_attributes(params[:announcement])
            @announcement.label = "from_principal"
            @announcement.save
            redirect resource(:from_principals)
         else
	          render :edit
         end
     end
  end
  
  def show
     @announcement = Announcement.find(params[:id])
     render
  end
  
  def delete
     if params[:label] == "attachment"
        @attachment = Attachment.find(params[:id])
        @announcement = Announcement.find_by_id(@attachment.attachable_id)
        @attachment.destroy
        @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
        @allowed = 1 - @attachments.count
        render :edit, :id => @announcement.id
     else
         @announcement = Announcement.find(params[:id])
         Attachment.delete_all(['attachable_id = ?', @announcement.id])
         @announcement.destroy
         redirect resource(:from_principals)
     end
  end
  
   def preview
      render :layout => 'preview'
   end
  
end
