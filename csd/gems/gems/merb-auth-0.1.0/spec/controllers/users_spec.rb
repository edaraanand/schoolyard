require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

def user_hash(options = {})
  { 'name'                   => 'ctran',
    'username'               => "ctran",
    'email'                  => "ctran@example.com",
    'password'               => "sekret",
    'password_confirmation'  => "sekret"}.merge(options)
end

describe MerbAuth::Users do
  before(:all) do
    require 'dm-core'
    DataMapper.setup(:default, 'sqlite3::memory:')
    MerbAuth.use_adapter(:datamapper)
    
    Merb::Router.prepare { |r| r.add_slice(:MerbAuth) } if standalone?
  end
  
  before(:each) do
    @user = mock("User", user_hash)
    MerbAuth::User.should_receive(:new).with(user_hash).and_return(@user)
  end
  
  it 'allows signup and redirect to /' do
    @user.should_receive(:save).and_return(true)
    
    controller = dispatch_to(MerbAuth::Users, :signup, {'merb_auth::user' => user_hash }, {:request_method => 'post'})
    controller.assigns(:user).should == @user
    controller.should redirect_to('/')
   end

   it 'reject signup and render errors in template' do
     @user.should_receive(:save).and_return(false)
     controller = dispatch_to(MerbAuth::Users, :signup, {'merb_auth::user' => user_hash}, {:request_method => 'post'}) {|c| 
       c.should_receive(:render)
     }
     controller.assigns(:user).should == @user
     controller.should respond_successfully
   end
end