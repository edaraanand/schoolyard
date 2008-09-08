require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-aggregates'

module MerbAuth
  module Adapter
    module Datamapper
      def self.included(base)
        base.class_eval do
          include ::DataMapper::Resource
          include MerbAuth::BaseModel
          extend ClassMethods
          
          storage_names[:default] = 'users'
          
          property :id, Integer, :serial => true
          property :name, String, :length => 3..40, :nullable => false
          property :username, String, :length => 3..40, :nullable => false
          property :email, String, :format => :email_address, :nullable => false
          property :crypted_password, String, :length => 40
          property :salt, String, :length => 40
          property :remember_token_expires_at, Date
          property :remember_token, String
          property :created_at, DateTime
          property :updated_at, DateTime
  
          validates_is_unique :username, :email
          validates_length :password, :in => 4..40, :if => :password_required?
          validates_is_confirmed :password, :groups => :create

          before :save, :encrypt_password
          
          def username=(value)
            attribute_set(:username, value.downcase) if value
          end
        end
      end
      
      module ClassMethods
        def create_db_table
          self.auto_migrate!
        end
        
        def drop_db_table
          self.repository do |r|
            r.adapter.destroy_model_storage(r, self)
          end
        end
        
        def find_by_id(id)
          MerbAuth::User.first(:id => id)
        end

        def find_by_remember_token(rt)
          MerbAuth::User.first(:remember_token => rt)
        end

        def find_by_username(username)
          if MerbAuth::User.properties[:activated_at]
            MerbAuth::User.first(:username => username, :activated_at.not => nil)
          else
            MerbAuth::User.first(:username => username)
          end
        end

        def find_by_activiation_code(activation_code)
          MerbAuth::User.first(:activation_code => activation_code)
        end
      end
    end
  end
end

MerbAuth.send(:remove_const, :User) if defined? MerbAuth::User
class MerbAuth::User
  include MerbAuth::Adapter::Datamapper
end