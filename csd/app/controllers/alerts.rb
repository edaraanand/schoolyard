class Alerts < Application
  layout 'myaccount'
  before :find_user, :exclude => [:update]

  def index
    @alert = @user.alerts.find(:first)
    render
  end

  def new
    @alert = @user.alerts.build
    render
  end

  def create
    @alert = @user.alerts.build(params[:alert])
    if @alert.save
      redirect url(:alerts)
    else
      render :new
    end
  end

  def edit
    @alert = @user.alerts.find(:first)
    render
  end

  def update
    @alert = Alert.find(:first, :conditions => ['user_id=?', current_user.id])
    if @alert.update_attributes(params[:alert])
      redirect url(:alerts)
    else
      render :edit
    end
  end

  private

  def find_user
    @user = User.find(:first, :conditions => ['id=?', current_user.id])
  end

end
