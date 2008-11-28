require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe School do

   before(:each) do
     @school = School.new({:school_name => 'Catholic School Department', :phone => '1234567899', :email => 'test@yahoo.com'})
   end
    
   it "should be invalid without a School Name" do
     @school.should be_valid
     @school.school_name = ''
     @school.should_not be_valid
     @school.errors.on(:school_name).should eql("can't be blank")
   end

   it "should be invalid without a Phone" do
     @school.should be_valid
     @school.phone = ''
     @school.should_not be_valid
     @school.errors.on(:phone).should eql("can't be blank")
   end
   
    it "should be invalid without a Email" do
     @school.should be_valid
     @school.email = ''
     @school.should_not be_valid
     @school.errors.on(:email).should eql("can't be blank")
   end
end