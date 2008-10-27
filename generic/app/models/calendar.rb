class Calendar < ActiveRecord::Base
	
      validates_presence_of :title
      validates_presence_of :start_date, :if => Proc.new{|c| c.day_event != true }
      validates_presence_of :end_date, :if => Proc.new{|c| c.day_event != true }	
      
      def validate
	      if ((self.start_date != nil) && (self.end_date != nil))
          self.errors.add(:end_date, "must be after the start date") if self.end_date < self.start_date
        end
         if ((self.day_event == false) && ((self.end_time != nil) && (self.start_time != nil)) )
           self.errors.add(:end_time, "must be greater than start time") if self.end_time <= self.start_time
         end
      end
  
end
 
