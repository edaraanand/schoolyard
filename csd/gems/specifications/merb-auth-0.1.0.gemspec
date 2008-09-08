Gem::Specification.new do |s|
  s.name = %q{merb-auth}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Cuong Tran"]
  s.date = %q{2008-06-11}
  s.description = %q{Merb Slice that provides user authentication}
  s.email = %q{ctran@pragmaquest.com}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["LICENSE", "README", "Rakefile", "lib/merb-auth", "lib/merb-auth/adapter", "lib/merb-auth/adapter/activerecord.rb", "lib/merb-auth/adapter/datamapper.rb", "lib/merb-auth/merbtasks.rb", "lib/merb-auth/model.rb", "lib/merb-auth/slicetasks.rb", "lib/merb-auth.rb", "spec/controllers", "spec/controllers/router_spec.rb", "spec/controllers/session_spec.rb", "spec/controllers/users_spec.rb", "spec/controllers/view_helper_spec.rb", "spec/merb-auth_spec.rb", "spec/models", "spec/models/ar_user_spec.rb", "spec/models/dm_user_spec.rb", "spec/models/shared_user_spec.rb", "spec/spec_helper.rb", "app/controllers", "app/controllers/application.rb", "app/controllers/controller_mixin.rb", "app/controllers/users.rb", "app/helpers", "app/helpers/application_helper.rb", "app/views", "app/views/layout", "app/views/layout/merb_auth.html.erb", "app/views/users", "app/views/users/login.html.erb", "app/views/users/signup.html.erb", "public/javascripts", "public/stylesheets", "public/stylesheets/master.css"]
  s.has_rdoc = true
  s.homepage = %q{http://merb-slices.rubyforge.org/merb-auth/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Merb Slice that provides user authentication}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<merb-slices>, [">= 0.9.4"])
    else
      s.add_dependency(%q<merb-slices>, [">= 0.9.4"])
    end
  else
    s.add_dependency(%q<merb-slices>, [">= 0.9.4"])
  end
end
