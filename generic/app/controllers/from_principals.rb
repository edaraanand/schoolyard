class FromPrincipals < Application
  layout 'default'
  before :find_school

  def index
    @announcements = @current_school.announcements.find(:all, :conditions => ['label=?', "from_principal"])
      #@announcements = Announcement.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 2
     #  @pager = ::Paginator.new(@current_school.announcements.size, 10) do |offset, per_page|
        #   Announcement.find(:all, :conditions => ["label = ? and school_id = ?", "from_principal", @current_school.id],  :limit => per_page, :offset => offset)
      # end  
      # @page = @pager.page(params[:page])
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
     @allowed = 1 - @attachments.size
     render
  end
  
  def update
     @announcement = Announcement.find(params[:id])
     @attachments = Attachment.find(:all, :conditions => ["attachable_id = ? and attachable_type =?", @announcement.id, "Announcement"])
     @allowed = 1 - @attachments.size
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
        @allowed = 1 - @attachments.size
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
