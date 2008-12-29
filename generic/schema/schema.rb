# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 48) do

  create_table "access_peoples", :force => true do |t|
    t.integer  "access_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subject_id"
    t.boolean  "home_page"
    t.integer  "class_id"
    t.boolean  "all"
  end

  create_table "accesses", :force => true do |t|
    t.string   "name"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alert_peoples", :force => true do |t|
    t.integer  "alert_id"
    t.integer  "person_id"
    t.boolean  "all"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alerts", :force => true do |t|
    t.string   "name"
    t.string   "full_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ancestors", :force => true do |t|
    t.integer  "student_id"
    t.integer  "protector_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcements", :force => true do |t|
    t.integer  "person_id"
    t.string   "access_name"
    t.string   "title"
    t.text     "content"
    t.date     "expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.boolean  "approved"
    t.boolean  "approve_announcement"
    t.boolean  "approve_by"
    t.boolean  "reject_by"
    t.text     "approve_comments"
    t.text     "reject_comments"
  end

  create_table "attachments", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendars", :force => true do |t|
    t.string   "class_name"
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.boolean  "day_event"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_peoples", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.integer  "team_id"
  end

  create_table "classrooms", :force => true do |t|
    t.string   "class_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "class_type"
    t.integer  "person_id"
  end

  create_table "classtypes", :force => true do |t|
    t.string   "class_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_links", :force => true do |t|
    t.string   "label"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forms", :force => true do |t|
    t.string   "title"
    t.string   "class_name"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guardians", :force => true do |t|
    t.integer  "student_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_works", :force => true do |t|
    t.integer  "classroom_id"
    t.string   "title"
    t.text     "content"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "person_bio"
    t.text     "address"
    t.string   "crypted_password"
    t.string   "salt"
    t.date     "birth_date"
    t.integer  "approved"
    t.string   "password_reset_key"
  end

  create_table "protectors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "parent_id"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.string   "current_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "school_name"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spot_lights", :force => true do |t|
    t.string   "class_name"
    t.string   "student_name"
    t.text     "content"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "studies", :force => true do |t|
    t.integer  "student_id"
    t.integer  "classroom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "team_name"
    t.integer  "classroom_id"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "salt"
    t.boolean  "active"
    t.string   "identity_url"
    t.string   "username"
  end

  create_table "welcome_messages", :force => true do |t|
    t.string   "access_name"
    t.integer  "person_id"
    t.string   "message"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
