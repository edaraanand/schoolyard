require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe WelcomeMessages, "index action" do
  before(:each) do
    dispatch_to(WelcomeMessages, :index)
  end
end