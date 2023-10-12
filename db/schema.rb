# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_12_185243) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "date"
    t.integer "status"
    t.integer "type"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status"
    t.bigint "notifications_config_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifications_config_id"], name: "index_notifications_on_notifications_config_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "notifications_configs", force: :cascade do |t|
    t.text "message_template"
    t.integer "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "program_attributes", force: :cascade do |t|
    t.integer "weight"
    t.bigint "program_id", null: false
    t.integer "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_program_attributes_on_program_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "registration_start_date"
    t.date "registration_end_date"
    t.date "begin_date"
    t.date "end_date"
    t.integer "registration_limit"
    t.boolean "active"
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.string "name"
    t.integer "step_order"
    t.boolean "submission"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "dates", default: [], array: true
    t.text "description"
    t.string "format"
    t.time "hour_start"
    t.time "hour_finish"
    t.index ["program_id"], name: "index_steps_on_program_id"
  end

  create_table "user_attributes", force: :cascade do |t|
    t.bigint "program_attribute_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_attribute_id"], name: "index_user_attributes_on_program_attribute_id"
    t.index ["user_id"], name: "index_user_attributes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.date "birth_date"
    t.string "phone"
    t.string "city"
    t.string "address"
    t.boolean "is_admin"
    t.text "about_me"
    t.integer "gender"
    t.integer "country"
    t.text "feedback"
    t.boolean "show_feedback"
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.boolean "participated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_users_events_on_event_id"
    t.index ["user_id"], name: "index_users_events_on_user_id"
  end

  create_table "users_programs_steps", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "program_id", null: false
    t.date "registration_date"
    t.bigint "step_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_users_programs_steps_on_program_id"
    t.index ["step_id"], name: "index_users_programs_steps_on_step_id"
    t.index ["user_id"], name: "index_users_programs_steps_on_user_id"
  end

  create_table "users_programs_steps_submissions", force: :cascade do |t|
    t.bigint "users_programs_step_id", null: false
    t.string "content"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["users_programs_step_id"], name: "index_upss_on_ups_id"
  end

  add_foreign_key "events", "users"
  add_foreign_key "notifications", "notifications_configs"
  add_foreign_key "notifications", "users"
  add_foreign_key "program_attributes", "programs"
  add_foreign_key "steps", "programs"
  add_foreign_key "user_attributes", "program_attributes"
  add_foreign_key "user_attributes", "users"
  add_foreign_key "users_events", "events"
  add_foreign_key "users_events", "users"
  add_foreign_key "users_programs_steps", "programs"
  add_foreign_key "users_programs_steps", "steps"
  add_foreign_key "users_programs_steps", "users"
  add_foreign_key "users_programs_steps_submissions", "users_programs_steps"
end
