class User < ActiveRecord::Base
  
	has_one :person
 
       #include MerbAuth::Adapter::ActiveRecord
       
end