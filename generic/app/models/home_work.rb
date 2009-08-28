class HomeWork < ActiveRecord::Base

  require 'base_ext'

  belongs_to :classroom
  belongs_to :person
  belongs_to :school
  validates_presence_of :title, :content, :due_date

  attr_accessor :attachment
  
  def validate
    if self.due_date != nil
      self.errors.add(:due_date, "must be greater than today") if self.due_date <= Date.today 
    end
  end
  
  validates_each :classroom_id do | record, attrib, value | 
      begin
         attrib.to_s.titleize.camelize.gsub(' ', '').constantize.find(value)
      rescue ActiveRecord::ActiveRecordError
         record.errors.add attrib, 'must be selected'
      end
  end
## Sending mail for Home Work Alert

  def mail(id)
    @current_school = self.school
    @person = @current_school.people.find_by_id(id)
    alert_deliver(:alert_details, @person, :subject => "Alert Details " + self.school.school_name)
  end

  def alert_deliver(action, to, params)
    @person = to 
    from = "noreply@schoolyardapp.com"
    PersonMailer.dispatch_and_deliver(action, params.merge(:from => from, :to => @person.email), self )
  end

end
