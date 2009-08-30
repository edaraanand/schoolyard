require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe SpotLights, "index action" do
  before(:each) do
    dispatch_to(SpotLights, :index)
  end
end