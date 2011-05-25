# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110525080025) do

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "date"
    t.string   "time"
    t.string   "place"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "works", :force => true do |t|
    t.string   "name"
    t.integer  "artist_id"
    t.string   "medium"
    t.string   "date"
    t.integer  "price"
    t.string   "status"
    t.string   "seller"
    t.string   "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
