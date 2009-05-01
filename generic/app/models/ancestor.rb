class Ancestor < ActiveRecord::Base

  belongs_to :student
  belongs_to :protector

end
