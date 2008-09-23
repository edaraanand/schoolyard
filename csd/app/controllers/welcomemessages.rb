class Welcomemessages < Application

  layout 'admin'
   before :access_rights

  def index
     @welcomemessages = Welcomemessage.find(:all)
     render
  end

  def new
    @welcomemessage = Welcomemessage.new
    render
  end

  def create
     @welcomemessage = Welcomemessage.new(params[:welcomemessage])
     if @welcomemessage.save
        redirect url(:welcomemessages)
     else
        render :new
     end
  end

  def edit
    @welcomemessage = Welcomemessage.find(params[:id])
    render
  end

  def update
     @welcomemessage = Welcomemessage.find(params[:id])
       if @welcomemessage.update_attributes(params[:welcomemessage])
           redirect url(:welcomemessages)
       else
           render :edit
       end
  end

  def preview
     render :layout => 'preview'
  end

  private

  def access_rights
     unless current_user.message_access == true
        redirect url(:homes)
     end
  end

end

