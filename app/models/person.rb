class Person < ActiveRecord::Base
  has_many :class_students
  #has_many :class_teachers
  has_many :classrooms, :through => :class_students
  #has_many :classrooms, :through => :class_teachers
  
  @@roles = %w(teacher student parent admin principle)
  
  def is_teacher?
    role == 'teacher'
  end
  
  def is_student?
    role == 'student'
  end
  
  def is_parent?
    role == 'parent'
  end
  
  def is_admin?
    role == 'admin'
  end
  
  def is_principle?
    role == 'principle'
  end
  
end