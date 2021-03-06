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

ActiveRecord::Schema.define(version: 20131122153432) do

  create_table "matches", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "player_1_id"
    t.integer  "player_2_id"
    t.integer  "round"
    t.integer  "game_1"
    t.integer  "game_2"
    t.integer  "game_3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["tournament_id"], name: "index_matches_on_tournament_id"

  create_table "player_tournaments", force: true do |t|
    t.integer  "player_id"
    t.integer  "tournament_id"
    t.integer  "bye_round"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "player_tournaments", ["player_id"], name: "index_player_tournaments_on_player_id"
  add_index "player_tournaments", ["tournament_id"], name: "index_player_tournaments_on_tournament_id"

  create_table "players", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.integer  "number_of_rounds"
    t.integer  "current_round"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "format"
    t.string   "location"
    t.date     "date"
    t.text     "details"
    t.boolean  "finished"
  end

  create_table "user_tournaments", force: true do |t|
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_tournaments", ["tournament_id"], name: "index_user_tournaments_on_tournament_id"
  add_index "user_tournaments", ["user_id"], name: "index_user_tournaments_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
