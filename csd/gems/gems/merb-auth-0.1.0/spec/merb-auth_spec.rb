require File.dirname(__FILE__) + '/spec_helper'

describe "MerbAuth (module)" do
  
  it "should be registered in Merb::Slices.slices" do
    Merb::Slices.slices.should include(MerbAuth)
  end
  
  it "should have an :identifier property" do
    MerbAuth.identifier.should == "merb-auth"
  end
  
  it "should have a :root property" do
    MerbAuth.root.should == current_slice_root
    MerbAuth.root_path('app').should == current_slice_root / 'app'
  end
  
  it "should have a dir_for method" do
    app_path = MerbAuth.dir_for(:application)
    app_path.should == current_slice_root / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbAuth.dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbAuth.dir_for(:public)
    public_path.should == current_slice_root / 'public'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuth.dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a app_dir_for method" do
    app_path = MerbAuth.app_dir_for(:application)
    app_path.should == Merb.root / 'slices' / 'merb-auth' / 'app'
    [:view, :model, :controller, :helper, :mailer, :part].each do |type|
      MerbAuth.app_dir_for(type).should == app_path / "#{type}s"
    end
    public_path = MerbAuth.app_dir_for(:public)
    public_path.should == Merb.dir_for(:public) / 'slices' / 'merb-auth'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuth.app_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
  it "should have a public_dir_for method" do
    public_path = MerbAuth.public_dir_for(:public)
    public_path.should == '/slices' / 'merb-auth'
    [:stylesheet, :javascript, :image].each do |type|
      MerbAuth.public_dir_for(type).should == public_path / "#{type}s"
    end
  end
  
end