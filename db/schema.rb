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

ActiveRecord::Schema.define(version: 20160906091745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "articles", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.string   "slug"
    t.integer  "topic_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "counter_cache", default: 0
  end

  add_index "articles", ["topic_id"], name: "index_articles_on_topic_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "file"
    t.integer  "file_size"
    t.string   "file_type"
    t.integer  "nbpages"
    t.decimal  "version_number"
    t.boolean  "active"
    t.integer  "product_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "position"
  end

  add_index "attachments", ["product_id"], name: "index_attachments_on_product_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.integer  "family_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position"
  end

  add_index "categories", ["family_id"], name: "index_categories_on_family_id", using: :btree
  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  add_index "categories_products", ["category_id"], name: "index_categories_products_on_category_id", using: :btree
  add_index "categories_products", ["product_id"], name: "index_categories_products_on_product_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.decimal  "score"
    t.integer  "product_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "customer_id"
  end

  add_index "comments", ["customer_id"], name: "index_comments_on_customer_id", using: :btree
  add_index "comments", ["product_id"], name: "index_comments_on_product_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "code2"
    t.string   "code3"
    t.string   "continent"
    t.string   "tld"
    t.string   "currency"
    t.boolean  "eu_member"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "mobile"
    t.string   "picture"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "email",                       default: "", null: false
    t.string   "encrypted_password",          default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "formatted_address"
    t.string   "street_address"
    t.string   "administrative_area_level_1"
    t.string   "administrative_area_level_2"
    t.string   "postal_code"
    t.string   "locality"
    t.decimal  "lat"
    t.decimal  "lng"
    t.date     "birthdate"
    t.decimal  "score_comments"
    t.integer  "nb_comments"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "language"
    t.integer  "country_id"
    t.string   "description"
    t.string   "slug"
    t.integer  "counter_cache",               default: 0
  end

  add_index "customers", ["confirmation_token"], name: "index_customers_on_confirmation_token", unique: true, using: :btree
  add_index "customers", ["country_id"], name: "index_customers_on_country_id", using: :btree
  add_index "customers", ["email"], name: "index_customers_on_email", unique: true, using: :btree
  add_index "customers", ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree
  add_index "customers", ["slug"], name: "index_customers_on_slug", unique: true, using: :btree

  create_table "cycles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "country_id"
  end

  add_index "cycles", ["country_id"], name: "index_cycles_on_country_id", using: :btree

  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.date     "entry_date"
    t.string   "mobile"
    t.string   "picture"
    t.string   "role"
    t.boolean  "active"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree
  add_index "employees", ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true, using: :btree

  create_table "families", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position"
    t.integer  "country_id"
  end

  add_index "families", ["country_id"], name: "index_families_on_country_id", using: :btree
  add_index "families", ["name"], name: "index_families_on_name", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "levels", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.integer  "cycle_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "levels", ["cycle_id"], name: "index_levels_on_cycle_id", using: :btree

  create_table "levels_products", id: false, force: :cascade do |t|
    t.integer "level_id"
    t.integer "product_id"
  end

  add_index "levels_products", ["level_id"], name: "index_levels_products_on_level_id", using: :btree
  add_index "levels_products", ["product_id"], name: "index_levels_products_on_product_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "product_id"
    t.decimal  "price",                precision: 8, scale: 2
    t.decimal  "tax_rate",             precision: 8, scale: 2
    t.decimal  "tax_amount",           precision: 8, scale: 2
    t.integer  "order_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "processing_reference"
    t.string   "method"
    t.string   "status"
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree
  add_index "order_items", ["product_id"], name: "index_order_items_on_product_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "token"
    t.string   "status"
    t.datetime "received_at"
    t.datetime "accepted_at"
    t.integer  "accepted_by"
    t.string   "consignment_number"
    t.datetime "rejected_at"
    t.integer  "rejected_by"
    t.string   "ip_address"
    t.text     "notes"
    t.decimal  "amount_paid",        precision: 8, scale: 2, default: 0.0
    t.boolean  "exported"
    t.string   "invoice_number"
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "order_id"
    t.decimal  "amount"
    t.string   "reference"
    t.boolean  "confirmed"
    t.boolean  "refundable"
    t.decimal  "amount_refunded"
    t.integer  "parent_payment_id"
    t.boolean  "exported"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "method"
  end

  add_index "payments", ["order_id"], name: "index_payments_on_order_id", using: :btree

  create_table "peers", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "peers", ["followed_id", "follower_id"], name: "index_peers_on_followed_id_and_follower_id", unique: true, using: :btree
  add_index "peers", ["followed_id"], name: "index_peers_on_followed_id", using: :btree
  add_index "peers", ["follower_id"], name: "index_peers_on_follower_id", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "sku"
    t.string   "permalink"
    t.string   "description"
    t.boolean  "active",                                 default: true
    t.decimal  "price",          precision: 8, scale: 2, default: 0.0
    t.boolean  "featured",                               default: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "customer_id"
    t.integer  "nb_comments"
    t.decimal  "score_comments"
    t.string   "slug"
    t.integer  "counter_cache",                          default: 0
  end

  add_index "products", ["customer_id"], name: "index_products_on_customer_id", using: :btree
  add_index "products", ["slug"], name: "index_products_on_slug", unique: true, using: :btree

  create_table "stripe_accounts", force: :cascade do |t|
    t.integer "customer_id"
    t.string  "publishable_key",       limit: 255
    t.string  "secret_key",            limit: 255
    t.string  "stripe_user_id",        limit: 255
    t.string  "currency",              limit: 255
    t.string  "stripe_account_type",   limit: 255
    t.text    "stripe_account_status",             default: "{}"
  end

  add_index "stripe_accounts", ["customer_id"], name: "index_stripe_accounts_on_customer_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.string   "slug"
    t.integer  "country_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "topics", ["country_id"], name: "index_topics_on_country_id", using: :btree

  create_table "wish_lists", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "product_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "wish_lists", ["customer_id"], name: "index_wish_lists_on_customer_id", using: :btree
  add_index "wish_lists", ["product_id"], name: "index_wish_lists_on_product_id", using: :btree

  add_foreign_key "articles", "topics"
  add_foreign_key "attachments", "products"
  add_foreign_key "categories", "families"
  add_foreign_key "comments", "customers"
  add_foreign_key "comments", "products"
  add_foreign_key "customers", "countries"
  add_foreign_key "cycles", "countries"
  add_foreign_key "families", "countries"
  add_foreign_key "levels", "cycles"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "customers"
  add_foreign_key "payments", "orders"
  add_foreign_key "products", "customers"
  add_foreign_key "stripe_accounts", "customers"
  add_foreign_key "topics", "countries"
  add_foreign_key "wish_lists", "customers"
  add_foreign_key "wish_lists", "products"
end
