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

ActiveRecord::Schema[7.0].define(version: 2024_08_01_162251) do
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

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id", null: false
    t.index ["event_id"], name: "index_categories_on_event_id"
  end

  create_table "categories_talks", force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categories_talks_on_category_id"
    t.index ["talk_id"], name: "index_categories_talks_on_talk_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "registration_start_date"
    t.index ["team_id"], name: "index_events_on_team_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.integer "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talk_id"], name: "index_materials_on_talk_id"
  end

  create_table "merches", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stock"
    t.text "custom_fields"
    t.index ["event_id"], name: "index_merches_on_event_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "description"
    t.integer "talk_id"
    t.integer "event_id"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["event_id"], name: "index_notifications_on_event_id"
    t.index ["talk_id"], name: "index_notifications_on_talk_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "score"
    t.integer "user_id", null: false
    t.integer "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talk_id"], name: "index_ratings_on_talk_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "merch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delivered", default: false
    t.integer "amount"
    t.text "options"
    t.index ["merch_id"], name: "index_reservations_on_merch_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "speakers", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.string "email"
    t.index ["event_id"], name: "index_speakers_on_event_id"
  end

  create_table "speakers_talks", force: :cascade do |t|
    t.integer "speaker_id", null: false
    t.integer "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["speaker_id"], name: "index_speakers_talks_on_speaker_id"
    t.index ["talk_id"], name: "index_speakers_talks_on_talk_id"
  end

  create_table "talks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "vacancy_limit"
    t.integer "event_id"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "speaker_id"
    t.integer "type_id"
    t.integer "category_id"
    t.index ["category_id"], name: "index_talks_on_category_id"
    t.index ["event_id"], name: "index_talks_on_event_id"
    t.index ["location_id"], name: "index_talks_on_location_id"
    t.index ["speaker_id"], name: "index_talks_on_speaker_id"
    t.index ["type_id"], name: "index_talks_on_type_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_teams_on_event_id"
  end

  create_table "teams_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_teams_users_on_team_id"
    t.index ["user_id"], name: "index_teams_users_on_user_id"
  end

  create_table "types", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "dre"
    t.integer "permissions", default: 1
    t.integer "team_id"
    t.integer "talk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 1
    t.string "cpf"
    t.string "ocupation"
    t.string "institution"
    t.index ["talk_id"], name: "index_users_on_talk_id"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  create_table "vacancies", force: :cascade do |t|
    t.boolean "presence", default: false
    t.integer "user_id", null: false
    t.integer "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talk_id"], name: "index_vacancies_on_talk_id"
    t.index ["user_id"], name: "index_vacancies_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "events"
  add_foreign_key "categories_talks", "categories"
  add_foreign_key "categories_talks", "talks"
  add_foreign_key "events", "teams"
  add_foreign_key "materials", "talks"
  add_foreign_key "merches", "events"
  add_foreign_key "notifications", "events"
  add_foreign_key "notifications", "talks"
  add_foreign_key "notifications", "users"
  add_foreign_key "ratings", "talks"
  add_foreign_key "ratings", "users"
  add_foreign_key "reservations", "merches"
  add_foreign_key "reservations", "users"
  add_foreign_key "speakers", "events"
  add_foreign_key "speakers_talks", "speakers"
  add_foreign_key "speakers_talks", "talks"
  add_foreign_key "talks", "categories"
  add_foreign_key "talks", "events"
  add_foreign_key "talks", "locations"
  add_foreign_key "talks", "speakers"
  add_foreign_key "talks", "types"
  add_foreign_key "teams", "events"
  add_foreign_key "users", "talks"
  add_foreign_key "users", "teams"
  add_foreign_key "vacancies", "talks"
  add_foreign_key "vacancies", "users"
end
