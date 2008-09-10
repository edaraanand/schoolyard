module MerbAuth
  module Adapter
    module ActiveRecord
      def self.included(base)
        base.class_eval do
          include MerbAuth::BaseModel
          extend ClassMethods
          
          validates_presence_of     :name
          validates_presence_of     :username
          validates_presence_of     :email
          validates_length_of       :username, :within => 3..40
         #  validates_length_of       :password, :within => 4..40, :if => :password_required?
         # validates_presence_of     :password_confirmation, :if => :password_required?
         # validates_confirmation_of :password, :if => :password_required?
          validates_uniqueness_of   :username, :case_sensitive => false, :if => lambda { |u| !u.username.blank? }
          validates_uniqueness_of   :email, :case_sensitive => false, :if => lambda { |u| !u.email.blank? }

          before_save :encrypt_password
          
          def username=(value)
            self[:username] = value.downcase if value
          end
        end
      end
      
      module ClassMethods
        def drop_db_table
          self.connection.drop_table("users")
        end
        
        def create_db_table
          self.connection.create_table("users") do |t|
            t.string :name, :limit => 40, :null => false
            t.string :username, :limit => 40, :null => false
            t.string :email, :null => false
            t.string :crypted_password, :limit => 40
            t.string :salt, :limit => 40, :null => false
            t.string :remember_token
            t.date :remember_token_expires_at
            t.timestamps
          end
        end  
      end
    end
  end
end

MerbAuth.send(:remove_const, :User) if defined? MerbAuth::User
class MerbAuth::User < ActiveRecord::Base
  include MerbAuth::Adapter::ActiveRecord
end
