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

ActiveRecord::Schema[7.0].define(version: 2022_08_04_111847) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "project_status", ["draft", "upcoming", "started", "completed"]

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_assignments_on_project_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "checklists", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount", default: 0, null: false
    t.boolean "is_rot"
    t.integer "position"
    t.index ["project_id"], name: "index_checklists_on_project_id"
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "nid"
    t.string "company_name"
    t.string "street_adress"
    t.integer "zipcode"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nid"], name: "index_clients_on_nid"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "contractors", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "fee"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
    t.string "cid"
    t.index ["user_id"], name: "index_contractors_on_user_id"
  end

  create_table "contractors_projects", id: false, force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "contractor_id"
    t.index ["contractor_id"], name: "index_contractors_projects_on_contractor_id"
    t.index ["project_id"], name: "index_contractors_projects_on_project_id"
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "salary"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pid"
    t.string "bank"
    t.string "account"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id"
    t.date "spent_on"
    t.string "category"
    t.string "description"
    t.float "amount", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_expenses_on_project_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "fees", force: :cascade do |t|
    t.string "reportee_type", null: false
    t.bigint "reportee_id", null: false
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reportee_type", "reportee_id"], name: "index_fees_on_reportee"
  end

  create_table "interns", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_interns_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_notes_on_project_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "access", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.date "payed_on"
    t.integer "amount"
    t.string "notes"
    t.index ["project_id"], name: "index_payments_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "client_id"
    t.string "title"
    t.string "adress"
    t.string "description"
    t.integer "material_amount", default: 0, null: false
    t.integer "misc_amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bonus", default: 0
    t.float "hourly_rate", default: 0.0, null: false
    t.float "fixed_fee"
    t.enum "status", default: "draft", null: false, enum_type: "project_status"
    t.date "starts_on"
    t.date "due_on"
    t.date "completed_on"
    t.date "payed_on"
    t.integer "seller_id"
    t.index ["status"], name: "index_projects_on_status"
  end

  create_table "reports", force: :cascade do |t|
    t.date "date"
    t.integer "time_in_minutes"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reportable_type"
    t.bigint "reportable_id"
    t.string "reportee_type"
    t.bigint "reportee_id"
    t.integer "fee"
    t.boolean "payable", default: true, null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable"
    t.index ["reportee_type", "reportee_id"], name: "index_reports_on_reportee"
  end

  create_table "todos", force: :cascade do |t|
    t.bigint "checklist_id", null: false
    t.boolean "completed"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["checklist_id"], name: "index_todos_on_checklist_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_manager", default: false
    t.boolean "is_admin", default: false
    t.string "first_name"
    t.string "last_name"
    t.string "presentation"
    t.string "phone"
    t.boolean "is_seller", default: false
    t.boolean "active", default: true, null: false
    t.index ["active"], name: "index_users_on_active"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assignments", "projects"
  add_foreign_key "assignments", "users"
  add_foreign_key "checklists", "projects"
  add_foreign_key "contractors", "users"
  add_foreign_key "employees", "users"
  add_foreign_key "expenses", "projects"
  add_foreign_key "expenses", "users"
  add_foreign_key "interns", "users"
  add_foreign_key "notes", "projects"
  add_foreign_key "notes", "users"
  add_foreign_key "payments", "projects"
  add_foreign_key "todos", "checklists"
end
