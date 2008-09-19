class Alert < ActiveRecord::Base
  belongs_to :user

  @@alert_msgs = {
    :announcement_alert => "New Announcement is Posted",
    :event_alert => "New Event is Posted",
    :message_alert => "New Message is Posted",
    :file_alert => "New File is posted"
  }


  def self.alert_msgs
    @@alert_msgs
  end

end
