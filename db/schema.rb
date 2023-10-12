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

ActiveRecord::Schema[7.0].define(version: 2023_10_12_131145) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

end
