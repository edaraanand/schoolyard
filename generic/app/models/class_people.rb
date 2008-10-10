class ClassPeople < ActiveRecord::Base
     belongs_to :classroom
     belongs_to :person
     belongs_to :team
end
