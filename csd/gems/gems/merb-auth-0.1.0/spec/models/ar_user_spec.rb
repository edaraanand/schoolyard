require File.join( File.dirname(__FILE__), "shared_user_spec")

require 'activerecord'

describe "User with Activerecord adapter" do
  before(:all) do
    ActiveRecord::Base.establish_connection(:adapter  => "sqlite3", :database => ":memory:")
    MerbAuth.use_adapter(:activerecord)
  end
  
  before(:each) do
    MerbAuth::User.create_db_table
  end
  
  after(:each) do
    MerbAuth::User.drop_db_table
  end
  
  it_should_behave_like "MerbAuth::User"
end