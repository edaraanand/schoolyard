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

end
