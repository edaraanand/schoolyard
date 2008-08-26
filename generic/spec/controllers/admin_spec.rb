require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Admin, "index action" do
  before(:each) do
    dispatch_to(Admin, :index)
  end
end