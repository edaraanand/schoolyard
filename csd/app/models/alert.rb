class Alert < ActiveRecord::Base
    belongs_to :user

   @@alert_msgs = {
          :announcement_alert => "New Announcement is Posted",
          :event_alert => "New Event is Posted",
          :message_alert => "New Message is Posted",
          :file_alert => "New File is posted"   }


     def self.alert_msgs
         @@alert_msgs
     end
     
   
    # def self.message
       ## @user = User.find(:first, :conditions => ['id=?', 19])
         #@alert = @user.alerts.find(:first)
       #Alert.alert_msgs.each { |key, value|
          #   if  @alert.#{key} == true
            #    puts "Eshwar"
            ###end
     
        
end


