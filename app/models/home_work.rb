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
    if self.classroom_id.nil?
       self.errors.add("classroom", "must be selected")
    end
  end
  
## Sending mail for Homework Alert

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
