require File.join( File.dirname(__FILE__), "shared_user_spec")

require 'dm-core'

describe "User with Datamapper adapter" do
  before(:all) do
    DataMapper.setup(:default, 'sqlite3::memory:')
    MerbAuth.use_adapter(:datamapper)
  end
  
  before(:each) do
    MerbAuth::User.create_db_table
  end
  
  after(:each) do
    MerbAuth::User.drop_db_table
  end

  it_should_behave_like "MerbAuth::User"
end


