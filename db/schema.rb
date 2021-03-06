# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171027182045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
  end

  create_table "hosts", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "hoster"
    t.string   "players"
    t.string   "vote"
    t.boolean  "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hosts", ["game_id"], name: "index_hosts_on_game_id", using: :btree

  create_table "joins", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "role"
    t.boolean  "vote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "seat"
  end

  add_index "joins", ["game_id"], name: "index_joins_on_game_id", using: :btree
  add_index "joins", ["user_id"], name: "index_joins_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tasks", ["game_id"], name: "index_tasks_on_game_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "image"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "hosts", "games"
  add_foreign_key "joins", "games"
  add_foreign_key "joins", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "tasks", "games"
end
