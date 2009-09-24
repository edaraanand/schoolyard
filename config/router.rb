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
    match("/reminder").to(:controller => 'notifications', :action => 'reminder').name(:reminder)
    match("/directions").to(:controller => 'notifications', :action => 'directions').name(:directions)
    match("/goodbye").to(:controller => 'notifications', :action => 'goodbye').name(:goodbye)
    
 
  authenticate do
       resources :parents
       resources :users
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
       resources :reports
       resources :from_principals
       resources :home_works
       resources :external_links
       resources :forms
       resources :spot_lights
       resources :admin
       resources :feedbacks
       resources :notifications
       resources :ranks
       resources :captures
       resources :tasks
       resources :directories
       match("/csv_errors").to(:controller => 'students', :action => 'csv_errors').name(:csv_errors)
       match("/edit_approve").to(:controller => 'approvals', :action => 'edit_approve').name(:edit_approve)
       match("/sms_log_details").to(:controller => 'notifications', :action => 'sms_log_details').name(:sms_log_details)
       match("/approved").to(:controller => 'approvals', :action => 'approved').name(:approved)
       match("/template_download").to(:controller => 'students', :action => 'template_download').name(:template_download)
       match("/import").to(:controller => 'students', :action => 'import').name(:import)
       match("/import_csv").to(:controller => 'students', :action => 'import_csv').name(:import_csv)
       match("/twilio_log").to(:controller => 'notifications', :action => 'twilio_log').name(:twilio_log)
       match("/staff").to(:controller => 'directories', :action => 'staff').name(:staff)
       match("/letters").to(:controller => 'directories', :action => 'letters').name(:letters)
       match("/generate_csv").to(:controller => 'directories', :action => 'generate_csv').name(:generate_csv)
       match("/progress_card").to(:controller => 'reports', :action => 'progress_card').name(:progress_card)
       match("/report_card").to(:controller => 'reports', :action => 'report_card').name(:report_card)
       match("/xls").to(:controller => 'captures', :action => 'xls').name(:xls)
       match("/activation").to(:controller => 'students', :action => 'activation').name(:activation)
       match("/create_task").to(:controller => 'tasks', :action => 'create').name(:create_task)
       match("/task_parents").to(:controller => 'captures', :action => 'task_parents').name(:task_parents)
       match("/update_task").to(:controller => 'tasks', :action => 'update').name(:update_task)
       match("/capture_tasks").to(:controller => 'captures', :action => 'capture_tasks').name(:capture_tasks)
       match("/spots").to(:controller => 'spot_lights', :action => 'spots').name(:spots)
       match("/class_works").to(:controller => 'home_works', :action => 'class_works').name(:class_works)
       match("/view_report").to(:controller => 'reports', :action => 'view_report').name(:view_report)
       match("/rank/edit").to(:controller => 'ranks', :action => 'edit').name(:ranks_edit)
       match("/rank/update").to(:controller => 'ranks', :action => 'update').name(:ranks_update)
       match("/add_grades").to(:controller => 'reports', :action => 'add_grades').name(:add_grades)
       match("/edit_grades").to(:controller => 'reports', :action => 'edit_grades').name(:edit_grades)
       match("/update_grades").to(:controller => 'reports', :action => 'update_grades').name(:update_grades)
       match("/score").to(:controller => 'reports', :action => 'score').name(:score)
       match("/grades").to(:controller => 'reports', :action => 'grades').name(:grades)
       match("/assignments").to(:controller => 'reports', :action => 'assignments').name(:assignments)
       match("/feedback_reply").to(:controller => 'feedbacks', :action => 'feedback_reply').name(:feedback_reply)
       match("/externallinks/edit").to(:controller => 'external_links', :action => 'edit').name(:external_links_edit)
       match("/externallinks/update").to(:controller => 'external_links', :action => 'update').name(:external_links_update)
       match("/alerts_edit").to(:controller => 'alerts', :action => 'edit').name(:alert_edit)
       match("/alerts_update").to(:controller => 'alerts', :action => 'update').name(:alert_update)
       match("/publish").to(:controller => 'approvals', :action => 'publish').name(:publish)
       match("/parent_approvals").to(:controller => 'approvals', :action => 'parent_approvals').name(:parent_approvals)
       match("/approval_review").to(:controller => 'approvals', :action => 'approval_review').name(:approval_review)
       match("/parent_grant").to(:controller => 'approvals', :action => 'parent_grant').name(:parent_grant)
       match("/principal_articles").to(:controller => 'homes', :action => 'principal_articles').name(:principal_articles)
       match("/class_details").to(:controller => 'classrooms', :action => 'class_details').name(:class_details)
       match("/form_files").to(:controller => 'forms', :action => 'form_files').name(:form_files)
       match("/events").to(:controller => 'calendars', :action => 'events').name(:events)
       match("/help").to(:controller => 'homes', :action => 'help').name(:help)
       match("/bio").to(:controller => 'homes', :action => 'bio').name(:bio)
       match("/disable").to(:controller => 'people', :action => 'disable').name(:disable)
       match("/enable").to(:controller => 'people', :action => 'enable').name(:enable)
       match("/download").to(:controller => 'files', :action => 'download').name(:download)
       match("/pdf_download").to(:controller => 'homes', :action => 'pdf_download').name(:pdf_download)
       match("/pdf_events").to(:controller => 'calendars', :action => 'pdf_events').name(:pdf_events)
       match("/home_works_pdf").to(:controller => 'home_works', :action => 'home_works_pdf').name(:home_works_pdf)
       match("/settings").to(:controller => 'from_principals', :action => 'settings').name(:settings)
       match("/settings_update").to(:controller => 'from_principals', :action => 'settings_update').name(:settings_update)
       match("/sports").to(:controller => 'teams', :action => 'sports').name(:sports)
       match("/school_admin").to(:controller => 'schools', :action => 'school_admin').name(:school_admin)
       match("/home_spot_light").to(:controller => 'homes', :action => 'home_spot_light').name(:home_spot_light)
       match("/lights").to(:controller => 'homes', :action => 'lights').name(:lights)
       match(:first_subdomain => 'admin').to(:controller => 'admin', :action => 'index') 
     
       match("/parent_account_edit").to(:controller => 'users', :action => 'parent_account_edit').name(:parent_account_edit)
       match("/parent_update").to(:controller => 'users', :action => 'parent_update').name(:parent_update)
       match("/staff_account_edit").to(:controller => 'users', :action => 'staff_account_edit').name(:staff_account_edit)
       match("/staff_account_update").to(:controller => 'users', :action => 'staff_account_update').name(:staff_account_update)
       match("/student_details").to(:controller => 'users', :action => 'student_details').name(:student_details)
       match("/student_edit").to(:controller => 'users', :action => 'student_edit').name(:student_edit)
       match("/student_update").to(:controller => 'users', :action => 'student_update').name(:student_update)
       match("/subscription").to(:controller => 'users', :action => 'subscription').name(:subscription)
       match("/phone").to(:controller => 'users', :action => 'phone').name(:phone)
       match("/voice_update").to(:controller => 'users', :action => 'voice_update').name(:voice_update)
       match("/password").to(:controller => 'users', :action => 'password').name(:password)
       match("/change_password").to(:controller => 'users', :action => 'change_password').name(:change_password)
       match("/check_type").to(:controller => 'homes', :action => 'check_type').name(:check_type)
       match("/account_type").to(:controller => 'homes', :action => 'account_type').name(:account_type)
   end
   
     
  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  default_routes
  
  # Change this for your home page to be available at /
 
    match('/').to(:controller => 'homes', :action => 'check_type').name(:check_type)

end