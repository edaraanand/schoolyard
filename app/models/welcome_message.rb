class WelcomeMessage < ActiveRecord::Base

  belongs_to :person
  belongs_to :school


  validates_presence_of :content
  validates_uniqueness_of :access_name, :scope => :school_id
   
  def validate
    if self.access_name == ""
       self.errors.add("please", "select the option")
    end
  end

end
