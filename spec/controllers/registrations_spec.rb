require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Registrations, "index action" do
  before(:each) do
    dispatch_to(Registrations, :index)
  end
end