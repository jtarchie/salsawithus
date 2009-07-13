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

ActiveRecord::Schema.define(:version => 20090421051034) do

  create_table "events", :force => true do |t|
    t.integer  "venue_id"
    t.integer  "user_id"
    t.integer  "modified_user_id"
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.string   "properties"
    t.integer  "minimum_age",      :default => 0
    t.datetime "date_start"
    t.datetime "date_end"
    t.string   "event_type"
    t.boolean  "disabled",         :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["date_start", "date_end"], :name => "index_events_on_date_start_and_date_end"
  add_index "events", ["venue_id", "user_id"], :name => "index_events_on_venue_id_and_user_id"

  create_table "facebook_templates", :force => true do |t|
    t.string "template_name", :null => false
    t.string "content_hash",  :null => false
    t.string "bundle_id"
  end

  add_index "facebook_templates", ["template_name"], :name => "index_facebook_templates_on_template_name", :unique => true

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "value",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reports", ["item_id", "item_type"], :name => "index_reports_on_item_id_and_item_type"

  create_table "users", :force => true do |t|
    t.integer  "facebook_id", :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"

  create_table "venues", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "url"
    t.string   "address"
    t.string   "phone_number"
    t.text     "description"
    t.float    "lat",              :default => 0.0
    t.float    "lng",              :default => 0.0
    t.boolean  "display",          :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "venue_type"
    t.integer  "modified_user_id"
  end

  add_index "venues", ["lat", "lng", "display"], :name => "index_venues_on_lat_and_lng_and_display"
  add_index "venues", ["user_id"], :name => "index_venues_on_user_id"

end
