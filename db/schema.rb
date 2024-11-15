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

ActiveRecord::Schema[7.1].define(version: 2024_06_30_041703) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "contacts", force: :cascade do |t|
    t.string "email", null: false
    t.string "phone", null: false
    t.string "mobile", null: false
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_contacts_on_email", unique: true
    t.index ["person_id"], name: "index_contacts_on_person_id"
  end

  create_table "job_roles", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "registration", null: false
    t.string "name", null: false
    t.date "date_birth"
    t.string "state_birth"
    t.string "city_birth"
    t.integer "marital_status"
    t.integer "gender"
    t.bigint "workspace_id"
    t.bigint "job_role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_people_on_deleted_at"
    t.index ["gender", "job_role_id"], name: "index_people_on_gender_and_job_role_id"
    t.index ["gender", "workspace_id"], name: "index_people_on_gender_and_workspace_id"
    t.index ["gender"], name: "index_people_on_gender"
    t.index ["job_role_id"], name: "index_people_on_job_role_id"
    t.index ["registration"], name: "index_people_on_registration", unique: true
    t.index ["workspace_id", "job_role_id"], name: "index_people_on_workspace_id_and_job_role_id", unique: true
    t.index ["workspace_id"], name: "index_people_on_workspace_id"
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contacts", "people"
  add_foreign_key "people", "job_roles"
  add_foreign_key "people", "workspaces"
end
