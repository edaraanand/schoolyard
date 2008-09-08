require File.join( File.dirname(__FILE__), "..", "spec_helper" )

def valid_user_hash(options = {})
  { :name                   => 'ctran',
    :username               => "ctran",
    :email                  => "ctran@example.com",
    :password               => "sekret",
    :password_confirmation  => "sekret"}.merge(options)
end

describe "MerbAuth::User", :shared => true do
  describe "username" do
    it "should require username field" do
      user = MerbAuth::User.new
      user.should respond_to(:username)
      user.should_not be_valid
      user.errors.on(:username).should_not be_nil
    end
  
    it "should fail validation with username less than 3 chars" do
      user = MerbAuth::User.new
      user.username = "AB"
      user.should_not be_valid
      user.errors.on(:username).should_not be_nil
    end
  
    it "should require username with between 3 and 40 chars" do
      user = MerbAuth::User.new(valid_user_hash(:username => nil))
      [3,40].each do |num|
        user.username = "a" * num
        user.should be_valid
        user.errors.on(:username).should be_nil
      end
    end
  
    it "should fail validation with username over 90 chars" do
      user = MerbAuth::User.new
      user.username = "A" * 41
      user.valid?
      user.errors.on(:username).should_not be_nil    
    end
  
    it "should make a valid user with all required fields set" do
      user = MerbAuth::User.new(valid_user_hash)
      user.save.should be_true
      user.errors.should be_empty    
    end
  
    it "should set timestamps after save" do
      user = MerbAuth::User.new(valid_user_hash)
      user.save.should be_true
      user.created_at.should_not be_nil
      user.updated_at.should_not be_nil   
    end
  
    it "should make sure username is unique" do
      user = MerbAuth::User.new( valid_user_hash(:username => "Daniel") )
      user2 = MerbAuth::User.new( valid_user_hash(:username => "Daniel"))
      user.save.should be_true
      user.username.should == "daniel"
      user2.save.should be_false
      user2.errors.on(:username).should_not be_nil
    end
  
    it "should make sure username is unique regardless of case" do
      user = MerbAuth::User.new( valid_user_hash(:username => "Daniel") )
      user2 = MerbAuth::User.new( valid_user_hash(:username => "daniel"))
      user.save.should be_true
      user.username = "Daniel"
      user2.save.should be_false
      user2.errors.on(:username).should_not be_nil
    end
  
    it "should downcase username" do
      user = MerbAuth::User.new( valid_user_hash(:username => "DaNieL"))
      user.username.should == "daniel"    
    end  
  
    it "should authenticate a user using a class method" do
      user = MerbAuth::User.new(valid_user_hash)
      user.save.should be_true
      MerbAuth::User.authenticate(valid_user_hash[:username], valid_user_hash[:password]).should_not be_nil
    end
  
    it "should not authenticate a user using the wrong password" do
      user = MerbAuth::User.new(valid_user_hash)  
      user.save.should be_true
      MerbAuth::User.authenticate(valid_user_hash[:username], "not_the_password").should be_nil
    end
  
    it "should not authenticate a user using the wrong username" do
      user = MerbAuth::User.create(valid_user_hash)  
      MerbAuth::User.authenticate("not_the_username", valid_user_hash[:password]).should be_nil
    end
  
    it "should not authenticate a user that does not exist" do
      MerbAuth::User.authenticate("i_dont_exist", "password").should be_nil
    end
  end

  describe "the password fields for User" do
    before(:each) do
      @user = MerbAuth::User.new( valid_user_hash )
    end
  
    it "should respond to password" do
      @user.should respond_to(:password)    
    end
  
    it "should respond to password_confirmation" do
      @user.should respond_to(:password_confirmation)
    end
  
    it "should have a protected password_required method" do
      @user.protected_methods.should include("password_required?")
    end
  
    it "should respond to crypted_password" do
      @user.should respond_to(:crypted_password)    
    end
  
    it "should require password if password is required" do
      user = MerbAuth::User.new( valid_user_hash(:password => nil))
      user.stub!(:password_required?).and_return(true)
      user.should_not be_valid
      user.errors.on(:password).should_not be_nil
      user.errors.on(:password).should_not be_empty
    end
  
    it "should set the salt" do
      user = MerbAuth::User.new(valid_user_hash)
      user.salt.should be_nil
      user.send(:encrypt_password)
      user.salt.should_not be_nil    
    end
  
    it "should require the password on create" do
      user = MerbAuth::User.new(valid_user_hash(:password => nil))
      user.save.should_not be_true
      user.errors.on(:password).should_not be_nil
      user.errors.on(:password).should_not be_empty
    end  
  
    it "should require password_confirmation if the password_required?" do
      user = MerbAuth::User.new(valid_user_hash(:password_confirmation => nil))
      user.save.should_not be_true
      (user.errors.on(:password) || user.errors.on(:password_confirmation)).should_not be_nil
    end
  
    it "should fail when password is outside 4 and 40 chars" do
      [3,41].each do |num|
        user = MerbAuth::User.new(valid_user_hash(:password => ("a" * num)))
        user.should_not be_valid
        user.errors.on(:password).should_not be_nil
      end
    end
  
    it "should pass when password is within 4 and 40 chars" do
      [4,30,40].each do |num|
        user = MerbAuth::User.new(valid_user_hash(:password => ("a" * num), :password_confirmation => ("a" * num)))
        user.should be_valid
        user.errors.on(:password).should be_nil
      end    
    end
  
    it "should autenticate against a password" do
      user = MerbAuth::User.new(valid_user_hash)
      user.save.should be_true
      user.should be_authenticated(valid_user_hash[:password])
    end
  
    it "should not require a password when saving an existing user" do
      user = MerbAuth::User.create(valid_user_hash)
      user = MerbAuth::User.find_by_username(valid_user_hash[:username])
      user.password.should be_nil
      user.password_confirmation.should be_nil
      user.username = "some_different_username_to_allow_saving"
      user.save.should be_true
    end
  end

  describe "remember_me" do
    predicate_matchers[:remember_token] = :remember_token?
  
    before do
      @user = MerbAuth::User.new(valid_user_hash)
    
      t = Date.today
      Date.stub!(:today).and_return(t)
    end
  
    it "should have a remember_token_expires_at attribute" do
      @user.attributes.keys.any?{|a| a.to_s == "remember_token_expires_at"}.should_not be_nil
    end  
  
    it "should return true if remember_token_expires_at is set and is in the future" do
      @user.remember_token_expires_at = Date.today + 7
      @user.should remember_token    
    end
  
    it "should set remember_token_expires_at to a specific date" do
      time = Date.new(2009,12,25)
      @user.remember_me_until(time)
      @user.remember_token_expires_at.should == time    
    end
  
    it "should set the remember_me token when remembering" do
      time = Date.new(2009,12,25)
      @user.remember_me_until(time)
      @user.remember_token.should_not be_nil
      @user.save
      @user = MerbAuth::User.find_by_username(valid_user_hash[:username])
      @user.remember_token.should_not be_nil
      @user.remember_token_expires_at.should == time
    end
  
    it "should set remember_me token for" do
      remember_until = Date.today + 7
      @user.remember_me_for(7)
      @user.remember_token_expires_at.should == (remember_until)
    end
  
    it "should remember_me token for two weeks" do
      @user.remember_me
      @user.remember_token_expires_at.should == (Date.today + 14)
    end
  
    it "should forget me" do
      @user.remember_me
      @user.save
      @user.forget_me
      @user.remember_token.should be_nil
      @user.remember_token_expires_at.should be_nil    
    end
  
    it "should persist the remember_me token to the database" do
      @user.remember_me
      @user.save
    
      @user = MerbAuth::User.find_by_username(valid_user_hash[:username])
      @user.remember_token.should_not be_nil
      @user.remember_token_expires_at == (Date.today + 14)
  
      @user.forget_me

      @user = MerbAuth::User.find_by_username(valid_user_hash[:username])
      @user.remember_token.should be_nil
      @user.remember_token_expires_at.should be_nil
    end
  end
end