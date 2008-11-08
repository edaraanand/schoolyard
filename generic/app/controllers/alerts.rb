class Alerts < Application
  layout 'admin_account'
  before :ensure_authenticated
  before :find_user
  
  def index
    @alerts = @person.alerts
    render
  end
  
  def new
    @alerts = Alert.find(:all)
    @alert_people = AlertPeople.new
    render
  end
  
  def create
    if params[:alert].nil?
        flash[:error]  = "You should check one of the checkboxes"
        render :new
    else
      @alerts = params[:alert][:alert_ids]
      @alerts.each do |f|
         AlertPeople.create({:alert_id => f, :person_id => @person.id })
      end
      redirect resource(:alerts)
    end  
  end
  
  def edit
    @alerts = Alert.find(:all)
    @alert_people = @person.alert_peoples
    render
  end
  
  def update
    if params[:alert].nil?
      flash[:error] = "You should check one of the checkboxes"
      render :edit
    else
      @alert = params[:alert][:alert_ids]
      alert_people = @person.alert_peoples
      alert_ids = alert_people.collect{|x| x.id } 
      alert = alert_people.collect{|x| x.alert_id }
     # s = @alert.zip(alert_ids)
      s = @alert.zip(alert_ids, alert)
      AlertPeople.destroy(alert_ids)
      s.each do |f|
         if f[1].nil?
            AlertPeople.create({:alert_id => f[0], :person_id => @person.id })
         elsif ((f[2].nil?) && f[1].nil?)
             AlertPeople.create({:alert_id => f[0], :person_id => @person.id })
         else
             AlertPeople.create({:alert_id => f[0], :person_id => @person.id })
         end
      end
      redirect resource(:alerts)
    end
  end
  
  
  private
  
  def find_user
    @person = session.user
  end

end
