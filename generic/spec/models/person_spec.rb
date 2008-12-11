require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Person do
  
  before(:each) do
    @person = Person.new({:first_name => 'test_first', :last_name => 'test_last', :email => 'testing@yahoo.com', :address => 'newyork'})
  end
    
   it "should be invalid without a First Name" do
     @person.should be_valid
     @person.first_name = ''
     @person.should_not be_valid
     @person.errors.on(:first_name).should eql("can't be blank")
   end

   it "should be invalid without a Last Name" do
     @person.should be_valid
     @person.last_name = ''
     @person.should_not be_valid
     @person.errors.on(:last_name).should eql("can't be blank")
   end
   
   it "should be invalid without a Email" do
     @person.should be_valid
     @person.email = ''
     @person.should_not be_valid
     @person.errors.on(:email).should eql("can't be blank")
   end
   
   it "should be invalid without a Address" do
     @person.should be_valid
     @person.address = ''
     @person.should_not be_valid
     @person.errors.on(:address).should eql("can't be blank")
   end

end