class Calendar < ActiveRecord::Base

  belongs_to :school

  validates_presence_of :title, :description
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :start_time, :if =>  Proc.new{|c| c.day_event != true}
  validates_presence_of :end_time, :if => Proc.new{|c| c.day_event != true }
   
  attr_accessor :attachment

  def validate
    if ((self.start_date != nil) && (self.end_date != nil))
      self.errors.add(:end_date, "must be after the start date") if self.end_date < self.start_date
    end
    if ((self.day_event != true) && ((self.end_time != nil) && (self.start_time != nil)) )
       self.errors.add(:end_time, "must be greater than start time") if ((self.end_time <= self.start_time) && (self.end_date <= self.start_date))
    end
    if self.class_name == ""
       self.errors.add(:class_name, "must be selected")
    end
  end
  
  
 
end

