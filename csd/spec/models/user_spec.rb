require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe User do

        before(:each) do
           @user = User.new({:first_name => 'Eshwar', :last_name => 'Gouthama', :email => 'test@org.com'})
        end

    it "should be invalid without a First Name" do
        @user.should be_valid
	@user.first_name = ''
	@user.should_not be_valid
        @user.errors.on(:first_name).should eql("can't be blank")
    end
    
    it "should be invalid without a Last Name" do
        @user.should be_valid
	@user.last_name = ''
	@user.should_not be_valid
        @user.errors.on(:last_name).should eql("can't be blank")
    end
    
    it "should be invalid without a Email" do
        @user.should be_valid
        @user.email = ''
        @user.should_not be_valid
        @user.errors.on(:email).should eql("can't be blank")
    end
       
    it "should have correctly formatted Email" do
        @user.should be_valid
	@user.email = 'test'
	@user.should_not be_valid
        @user.errors.on(:email).should eql("is invalid")
    end

    it "should not contain duplicate Email" do
           user = User.new(:first_name => 'test', :last_name => 'ing', :email => 'esh@gmail.com')
          if user.valid?
              user.should be_valid
          elsif
             user.email = 'test@org.com'
             user.should_not be_valid
             user.errors.on(:email).should eql("has already been taken")
          end   
    end
   

   
end
