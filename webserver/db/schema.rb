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

ActiveRecord::Schema.define(version: 2018_06_26_005246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discord_users", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "icon"
    t.string "email"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "discriminator"
    t.string "token"
    t.index ["user_id"], name: "index_discord_users_on_user_id"
  end

  create_table "twitch_chat_keys", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "token"
    t.text "targetChannels", default: [], array: true
    t.boolean "enabled"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_twitch_chat_keys_on_user_id"
  end

  create_table "twitch_users", force: :cascade do |t|
    t.string "uid"
    t.string "name"
    t.string "icon"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.integer "timeWatched", default: 0, null: false
    t.index ["user_id"], name: "index_twitch_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "sheep"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "owner"
  end

end
