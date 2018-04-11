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

ActiveRecord::Schema.define(version: 20180409190648) do

  create_table "alert_subscribes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "container_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "notification_type"
    t.index ["container_id"], name: "index_alert_subscribes_on_container_id"
    t.index ["user_id"], name: "index_alert_subscribes_on_user_id"
  end

  create_table "containers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "number"
  end

  create_table "lines", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "description"
    t.integer  "n_actors"
    t.integer  "n_stages"
    t.integer  "container_id"
    t.index ["container_id"], name: "index_lines_on_container_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string   "name"
    t.integer  "line_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
    t.integer  "n_actors"
    t.integer  "n_process"
    t.index ["line_id"], name: "index_stages_on_line_id"
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.integer  "stage_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "description"
    t.integer  "n_actors"
    t.integer  "n_sub_process"
    t.string   "sub_state"
    t.string   "alert"
    t.string   "st_machine"
    t.index ["stage_id"], name: "index_states_on_stage_id"
  end

  create_table "substates", force: :cascade do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_substates_on_state_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
