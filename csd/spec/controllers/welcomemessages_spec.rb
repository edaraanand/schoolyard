require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Welcomemessages, "index action" do
  before(:each) do
    dispatch_to(Welcomemessages, :index)
  end
end