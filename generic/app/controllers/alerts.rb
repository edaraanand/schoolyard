class Alerts < Application
  layout 'account'
  before :ensure_authenticated
  before :find_user
  before :selected_link
  
  def index
    @alerts = @person.alerts
    @alert_people = AlertPeople.find(:all,:conditions=>['person_id=?', session.user.id]).map{|x| x.alert_id }	
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
    render
  end
  
  def update
    AlertPeople.delete_all(['person_id=?', session.user.id])
    if params[:selected_alerts]
      params[:selected_alerts].each do |key,data|
  	  	people_alert_to_save = AlertPeople.new
  			people_alert_to_save.person_id = session.user.id
  			people_alert_to_save.alert_id = key
  			people_alert_to_save.save
  		end
    end
    # if params[:class_alerts]
    #   # raise params.inspect
    # end
    redirect resource(:alerts)
  end  
    
      
    # if params[:alert].nil?
    #      flash[:error] = "You should check one of the checkboxes"
    #      render :edit
    #    else
    #      @alert = params[:alert][:alert_ids]
    #      alert_people = @person.alert_peoples
    #      alert_ids = alert_people.collect{|x| x.id } 
    #      alert = alert_people.collect{|x| x.alert_id }
    #      s = @alert.zip(alert_ids, alert)
    #      AlertPeople.destroy(alert_ids)
    #      s.each do |f|
    #         if f[1].nil?
    #            AlertPeople.create({:alert_id => f[0], :person_id => @person.id })
    #         elsif ((f[2].nil?) && f[1].nil?)
    #             AlertPeople.create({:alert_id => f[0], :person_id => @person.id })
    #         else
    #             AlertPeople.create({:alert_id => f[0], :person_id => @person.id })
    #         end
    #      end
    #      redirect resource(:alerts)
    #    end
   
  
  private
  
  def find_user
    @person = session.user
      if @person.type == "Staff"
         @alerts = Alert.find(:all, :conditions => ['type == ?', "Staff"])
      else
         @few_alerts = Alert.find(:all, :conditions =>['type == ?', "Parent"], :order => "id desc", :limit => 2)
         @alerts = Alert.find(:all, :conditions =>['type == ?', "Parent"], :order => "id ASC", :limit => 2)
      end
      @alert_people = AlertPeople.find(:all,:conditions=>['person_id=?', session.user.id]).map{|x| x.alert_id }
  end

  def selected_link
     @selected = "alerts"
  end
  
  
end
