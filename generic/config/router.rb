# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   r.match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   r.match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   r.match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do 
  
  module Merb
    class Request
      def first_subdomain
          subdomains.first
      end
    end
  end

  # RESTful routes
  
 #r.add_slice(:MerbAuth, 'auth')
  
  #match("/login").
   # to(:controller => 'sessions', :action => 'new').
    #name(:login)
  #match("/logout").
   # to(:controller => 'sessions', :action => 'destroy').
    #name(:logout)
  
  
    slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "") 
    resources :registrations
    match("/registration_process").to(:controller => 'registrations', :action => 'registration_process').name(:registration_process)
    match("/registration_last").to(:controller => 'registrations', :action => 'registration_last').name(:registration_last)
    match("/password_save").to(:controller => 'registrations', :action => 'password_save').name(:password_save)
    match("/new_password").to(:controller => 'registrations', :action => 'new_password').name(:new_password)
    match("/password_new").to(:controller => 'registrations', :action => 'password_new').name(:password_new)
    match("/password_sent").to(:controller => 'registrations', :action => 'password_sent').name(:password_sent)
    match("/forgot_password").to(:controller => 'registrations', :action => 'forgot_password').name(:forgot_password)
    match("/get_password").to(:controller => 'registrations', :action => 'get_password').name(:get_password)
    match("/reset_password").to(:controller => 'registrations', :action => 'reset_password').name(:reset_password)
    match("/reset_password_edit").to(:controller => 'registrations', :action => 'reset_password_edit').name(:reset_password_edit)
    match("/reset_password_update").to(:controller => 'registrations', :action => 'reset_password_update').name(:reset_password_update)
    match("/new_staff_password").to(:controller => 'registrations', :action => 'new_staff_password').name(:new_staff_password)
    match("/password_staff").to(:controller => 'registrations', :action => 'password_staff').name(:password_staff)
    match("/staff_password_save").to(:controller => 'registrations', :action => 'staff_password_save').name(:staff_password_save)

 
  authenticate do
       resources :parents
       resources :approvals
       resources :schools
       resources :people
       resources :alerts
       resources :classrooms
       resources :homes
       resources :announcements
       resources :welcome_messages
       resources :calendars
       resources :students
       resources :teams
       resources :from_principals
       resources :home_works
       resources :external_links
       resources :forms
       resources :spot_lights
       resources :admin
       resources :feedbacks
       #resources :reports
       match("/feedback_reply").to(:controller => 'feedbacks', :action => 'feedback_reply').name(:feedback_reply)
       match("/externallinks/edit").to(:controller => 'external_links', :action => 'edit').name(:external_links_edit)
       match("/externallinks/update").to(:controller => 'external_links', :action => 'update').name(:external_links_update)
       match("/alerts_edit").to(:controller => 'alerts', :action => 'edit').name(:alert_edit)
       match("/alerts_update").to(:controller => 'alerts', :action => 'update').name(:alert_update)
       match("/staff_account").to(:controller => 'users', :action => 'staff_account').name(:staff_account)
       match("/staff_account_edit").to(:controller => 'users', :action => 'staff_account_edit').name(:staff_account_edit)
       match("/staff_account_update").to(:controller => 'users', :action => 'staff_account_update').name(:staff_account_update)
       match("/staff_password").to(:controller => 'users', :action => 'staff_password').name(:staff_password)
       match("/staff_password_update").to(:controller => 'users', :action => 'staff_password_update').name(:staff_password_update)
       match("/publish").to(:controller => 'approvals', :action => 'publish').name(:publish)
       match("/parent_approvals").to(:controller => 'approvals', :action => 'parent_approvals').name(:parent_approvals)
       match("/approval_review").to(:controller => 'approvals', :action => 'approval_review').name(:approval_review)
       match("/parent_grant").to(:controller => 'approvals', :action => 'parent_grant').name(:parent_grant)
       match("/principal_articles").to(:controller => 'homes', :action => 'principal_articles').name(:principal_articles)
       match("/class_details").to(:controller => 'classrooms', :action => 'class_details').name(:class_details)
       match("/form_files").to(:controller => 'forms', :action => 'form_files').name(:form_files)
       match("/parent_account").to(:controller => 'users', :action => 'parent_account').name(:parent_account)
       match("/parent_password").to(:controller => 'users', :action => 'parent_password').name(:parent_password)
       match("/parent_password_change").to(:controller => 'users', :action => 'parent_password_change').name(:parent_password_change)
       match("/parent_account_edit").to(:controller => 'users', :action => 'parent_account_edit').name(:parent_account_edit)
       match("/parent_update").to(:controller => 'users', :action => 'parent_update').name(:parent_update)
       match("/student_details").to(:controller => 'users', :action => 'student_details').name(:student_details)
       match("/student_edit").to(:controller => 'users', :action => 'student_edit').name(:student_edit)
       match("/student_update").to(:controller => 'users', :action => 'student_update').name(:student_update)
       match("/directory").to(:controller => 'students', :action => 'directory').name(:directory)
       match("/staff").to(:controller => 'students', :action => 'staff').name(:staff)
       match("/events").to(:controller => 'calendars', :action => 'events').name(:events)
       match("/help").to(:controller => 'homes', :action => 'help').name(:help)
       match("/bio").to(:controller => 'homes', :action => 'bio').name(:bio)
       match("/disable").to(:controller => 'people', :action => 'disable').name(:disable)
       match("/enable").to(:controller => 'people', :action => 'enable').name(:enable)
       match("/download").to(:controller => 'homes', :action => 'download').name(:download)
       match("/pdf_download").to(:controller => 'homes', :action => 'pdf_download').name(:pdf_download)
       match("/pdf_events").to(:controller => 'calendars', :action => 'pdf_events').name(:pdf_events)
       match("/generate_csv").to(:controller => 'students', :action => 'generate_csv').name(:generate_csv)
       match("/home_works_pdf").to(:controller => 'home_works', :action => 'home_works_pdf').name(:home_works_pdf)
       match("/settings").to(:controller => 'from_principals', :action => 'settings').name(:settings)
       match("/settings_update").to(:controller => 'from_principals', :action => 'settings_update').name(:settings_update)
       match("/sports").to(:controller => 'teams', :action => 'sports').name(:sports)
       match("/school_admin").to(:controller => 'schools', :action => 'school_admin').name(:school_admin)
       match("/home_spot_light").to(:controller => 'homes', :action => 'home_spot_light').name(:home_spot_light)
       match("/lights").to(:controller => 'homes', :action => 'lights').name(:lights)
       match("/new_settings").to(:controller => 'from_principals', :action => 'new_settings').name(:new_settings)
       match("/create_settings").to(:controller => 'from_principals', :action => 'create_settings').name(:create_settings)
       match("/edit_details").to(:controller => 'from_principals', :action => 'edit_details').name(:edit_details)
       match("/update_details").to(:controller => 'from_principals', :action => 'update_details').name(:update_details)
       match(:first_subdomain => 'admin').to(:controller => 'admin', :action => 'index') 
   end
   
     
  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  default_routes
  
  # Change this for your home page to be available at /
 
    match('/').to(:controller => 'homes')

end