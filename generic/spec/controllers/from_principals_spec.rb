require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe FromPrincipals, "index action" do
  before(:each) do
    dispatch_to(FromPrincipals, :index)
  end
end