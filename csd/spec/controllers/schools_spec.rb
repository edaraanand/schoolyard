require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Schools, "index action" do
  before(:each) do
    dispatch_to(Schools, :index)
  end
end