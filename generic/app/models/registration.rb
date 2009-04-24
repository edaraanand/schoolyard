class Registration < ActiveRecord::Base

  belongs_to :school

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :current_class
  validates_presence_of :birth_date

  def name
    "#{first_name}"  "     "    "#{last_name}"
  end

end
