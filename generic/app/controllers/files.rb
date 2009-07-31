class Files < Application

  before :ensure_authenticated
  before :find_school
  
   
  def index
    render
  end
  
  def download
     @attachment = @current_school.attachments.find_by_id(params[:id])
     raise NotFound unless @attachment
     send_file("#{Merb.root}/public/uploads/#{@current_school.id}/files/#{@attachment.id}") 
  end
  
end
