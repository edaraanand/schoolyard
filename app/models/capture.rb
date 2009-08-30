class Capture < ActiveRecord::Base
  
  belongs_to :school
  has_many :tasks
  
  attr_accessor :content
  
  # Validations
  validates_presence_of :title, :scope => :school_id
  validates_presence_of :expiration
  validates_presence_of :content
  
  def validate
     if self.expiration != nil
        self.errors.add(:expiration, "must be greater than today") if self.expiration <= Date.today 
     end
  end
  
  
end
