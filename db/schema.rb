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

ActiveRecord::Schema.define(version: 20171211133354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doctags", force: :cascade do |t|
    t.bigint "document_id"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_doctags_on_document_id"
    t.index ["tag_id"], name: "index_doctags_on_tag_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "selected", default: false
    t.string "photo"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "logo"
    t.integer "budgea_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "personnal", default: false
  end

  create_table "user_services", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "service_id"
    t.integer "connection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_user_services_on_service_id"
    t.index ["user_id"], name: "index_user_services_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.string "budgea_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "doctags", "documents"
  add_foreign_key "doctags", "tags"
  add_foreign_key "documents", "users"
  add_foreign_key "user_services", "services"
  add_foreign_key "user_services", "users"
end
