class Form < ActiveRecord::Base

  attr_accessor :attachment

  belongs_to :school

  validates_presence_of :title, :description
   
  def validate
    if self.class_name
      if self.class_name == ""
         self.errors.add("please", "select the class")
      end
    end
  end
  
  def self.all_forms(id)
    self.find(:all, :conditions => ["class_name = ? and school_id = ?", "All Classes", id ])
  end

end
