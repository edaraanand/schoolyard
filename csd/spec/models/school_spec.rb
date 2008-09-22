require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe School do

    before(:each) do
    @school = School.new({:school_name => 'Catholic School Department', :contact_information => 'The catholic school is a good school and it is a famous school'})
    end

   it "should be invalid without a Contact Information" do
     @school.should be_valid
     @school.contact_information = ''
     @school.should_not be_valid
     @school.errors.on(:contact_information).should eql("can't be blank")
   end
   
  

end

 
