class Alerts < Application
  layout 'account'
  before :ensure_authenticated
  before :find_user
  before :selected_link
  
  def index
    @alerts = @person.alerts.uniq
    @alert_people = AlertPeople.find(:all,:conditions=>['person_id=?', session.user.id]).map{|x| x.alert_id }
    render
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
    if session.user.type == "Parent"
       if params[:class_alerts] || params[:parent_alerts]
          if params[:parent_alerts].nil? &&  params[:class_alerts] != nil
             flash[:error] = "you should check the Announcement/Homework"
             render :edit
          elsif params[:class_alerts].nil? && params[:parent_alerts] != nil
             flash[:error] = "you should check the Classroom"
             render :edit
          else
             params[:class_alerts].each do |k, d|
               params[:parent_alerts].each do |key, data|
                 people_alert_to_save = AlertPeople.new
                 people_alert_to_save.person_id = session.user.id
                 people_alert_to_save.alert_id = key
                 people_alert_to_save.classroom_id = k
                 people_alert_to_save.save
               end
             end
             redirect resource(:alerts)
           end
        else
          redirect resource(:alerts)
        end
     else
       @alert = Alert.find_by_name("announcement")
       params[:class_alerts].each do |k, d|
          people_alert_to_save = AlertPeople.new
          people_alert_to_save.person_id = session.user.id
          people_alert_to_save.alert_id = @alert.id
          people_alert_to_save.classroom_id = k
          people_alert_to_save.save
       end
       redirect resource(:alerts)
     end
  end  
    
  
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
