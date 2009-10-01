class Calendar < ActiveRecord::Base

  belongs_to :school

  validates_presence_of :title, :description
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :start_time, :if => Proc.new{|c| c.day_event != true}
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
    if self.start_date != nil
       self.errors.add(:start_date, "must be equal or greater than today") if self.start_date < Date.today 
    end
  end
  
  
  def self.all_calendars(id, class_name)
    school_calendar = self.find(:all, :conditions => ["class_name = ? and school_id = ?", "Schoolwide", id ], :order => "start_date")
    class_calendar = self.find(:all, :conditions => ["class_name = ? and school_id = ?", "#{class_name}", id] )
    class_calendar.concat(school_calendar).sort_by{|my_item| my_item[:start_date]}.uniq
  end
  
  def self.today_calendars(id, class_name)
    school_calendar = self.find(:all, :conditions => ["class_name = ? and start_date = ? and school_id = ?", "Schoolwide", Date.today, id ])
    class_calendar = self.find(:all, :conditions => ["class_name = ? and start_date = ? and school_id = ?", "#{class_name}", Date.today, id ])
    class_calendar.concat(school_calendar).sort_by{|my_item| my_item[:start_date]}.uniq
  end
  
   
  ############################## WEEK CALENDARS #################################

  def self.current_week_calendars(id, class_name, week)
     @current_school = School.find_by_id(id)
     weeks = Date.today.beginning_of_week + ( 7 * (week.to_i) )
     from = weeks.beginning_of_week
     to = weeks.end_of_week
     school_calendar = @current_school.calendars.find(:all, :conditions => {:start_date => from..to, :class_name => "Schoolwide"})
     class_calendar =  @current_school.calendars.find(:all, :conditions => {:start_date => from..to, :class_name => "#{class_name}"})
     class_calendar.concat(school_calendar).sort_by{|my_item| my_item[:start_date]}.uniq
  end
  
  def self.all_week_calendars(id, week)
     @current_school = School.find_by_id(id)
     weeks = Date.today.beginning_of_week + ( 7 * (week.to_i) )
     from = weeks.beginning_of_week
     to = weeks.end_of_week
     class_calendar =  @current_school.calendars.find(:all, :conditions => {:start_date => from..to})
  end
  
  
   
end

