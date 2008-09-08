require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Session Controller", "index action" do
  before(:all) do    
    Merb::Router.prepare { |r| r.add_slice(:MerbAuth) } if standalone?
  end

  def login_with(params = {}, &blk)
    dispatch_to(MerbAuth::Users, :login, params, {:request_method => 'post'}, &blk)
  end

  def logout(&blk)
    dispatch_to(MerbAuth::Users, :logout, {}, {}, &blk)
  end
  
  it 'logins and redirects' do
    controller = login_with(:username => 'quentin', :password => 'test') {|c|
      c.should_receive(:verify_login).with('quentin', 'test').and_return(mock("User", :id => 1, :name => 'quentin'))
    }
    
    controller.session[:user].should_not be_nil
    controller.session[:user].should == 1
    controller.should redirect_to("/")
  end
   
  it 'fails login and does not redirect' do
    controller = login_with(:username => 'quentin', :password => 'bad password') {|c|
      c.should_receive(:verify_login).with('quentin', 'bad password').and_return(nil)
    }
    controller.session[:user].should be_nil
    controller.should be_successful
  end

  it 'logs out' do
    controller = logout {|c| 
      c.stub!(:current_user).and_return(mock("User", :forget_me => true)) 
    }
    controller.session[:user].should be_nil
    controller.should redirect
  end

  it 'remembers me' do
    controller = login_with(:username => 'quentin', :password => 'test', :remember_me => "1") {|c|
      user = mock("User", :id => 1)
      c.should_receive(:verify_login).with('quentin', 'test').and_return(user)
      user.should_receive(:remember_me)
      user.should_receive(:remember_token).and_return("abc123")
      user.should_receive(:remember_token_expires_at).and_return(Date.today)
    }
    controller.cookies["auth_token"].should_not be_nil
  end
 
  it 'does not remember me' do
    controller = login_with(:username => 'quentin', :password => 'test', :remember_me => "0") {|c|
      user = mock("User", :id => 1)
      c.should_receive(:verify_login).with('quentin', 'test').and_return(user)
    }
    controller.cookies["auth_token"].should be_nil
  end
  
  it 'deletes token on logout' do
    controller = logout {|c| controller.stub!(:current_user).and_return(@quentin) }
    controller.cookies["auth_token"].should == nil
  end
  
  
  it 'logs in with cookie' do
    controller = login_with do |c|
      c.request.env[Merb::Const::HTTP_COOKIE] = "auth_token=abc123"
      c.should_receive(:verify_login).and_return(nil)
      user = mock("User", :id => 1, :remember_token? => true)
      c.should_receive(:find_user_by_remember_token).with('abc123').and_return(user)
      user.should_receive(:remember_me)
      user.should_receive(:remember_token).and_return("abc123")
      user.should_receive(:remember_token_expires_at).and_return(Date.today)
    end
    controller.should be_logged_in
  end

  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(user)
    auth_token user.remember_token
  end
end