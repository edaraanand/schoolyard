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

ActiveRecord::Schema.define(:version => 6) do

  create_table "announcements", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.date     "expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendars", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "homelinks", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "school_name"
    t.text     "contact_information"
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :limit => 40, :null => false
    t.string   "username",                  :limit => 40, :null => false
    t.string   "email",                                   :null => false
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40, :null => false
    t.string   "remember_token"
    t.date     "remember_token_expires_at"
    t.string   "phone"
    t.boolean  "content_access"
    t.boolean  "manage_access"
    t.boolean  "settings_access"
    t.boolean  "event_access"
    t.boolean  "message_access"
    t.boolean  "links_access"
    t.boolean  "announcement_access"
    t.boolean  "files_access"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
