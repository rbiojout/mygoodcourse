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

ActiveRecord::Schema.define(version: 20161104150227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"
  enable_extension "unaccent"

  create_table "abuses", force: :cascade do |t|
    t.string  "abusable_type"
    t.integer "abusable_id"
    t.integer "customer_id"
    t.text    "description"
    t.string  "status"
    t.index ["abusable_type", "abusable_id"], name: "index_abuses_on_abusable_type_and_abusable_id", using: :btree
    t.index ["customer_id"], name: "index_abuses_on_customer_id", using: :btree
  end

  create_table "articles", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.string   "slug"
    t.integer  "topic_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "counter_cache", default: 0
    t.index ["topic_id"], name: "index_articles_on_topic_id", using: :btree
  end

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
    t.binary   "iv"
    t.binary   "key"
    t.index ["product_id"], name: "index_attachments_on_product_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.integer  "family_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position"
    t.index ["family_id"], name: "index_categories_on_family_id", using: :btree
    t.index ["name"], name: "index_categories_on_name", using: :btree
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "product_id"
    t.index ["category_id"], name: "index_categories_products_on_category_id", using: :btree
    t.index ["product_id"], name: "index_categories_products_on_product_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "text"
    t.integer  "customer_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["customer_id"], name: "index_comments_on_customer_id", using: :btree
  end

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
    t.decimal  "score_reviews"
    t.integer  "nb_reviews"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "language"
    t.integer  "country_id"
    t.string   "description"
    t.string   "slug"
    t.integer  "counter_cache",               default: 0
    t.index ["confirmation_token"], name: "index_customers_on_confirmation_token", unique: true, using: :btree
    t.index ["country_id"], name: "index_customers_on_country_id", using: :btree
    t.index ["email"], name: "index_customers_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_customers_on_slug", unique: true, using: :btree
  end

  create_table "cycles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "country_id"
    t.index ["country_id"], name: "index_cycles_on_country_id", using: :btree
  end

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
    t.index ["email"], name: "index_employees_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true, using: :btree
  end

  create_table "families", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position"
    t.integer  "country_id"
    t.index ["country_id"], name: "index_families_on_country_id", using: :btree
    t.index ["name"], name: "index_families_on_name", using: :btree
  end

  create_table "forum_answers", force: :cascade do |t|
    t.text     "text"
    t.integer  "customer_id"
    t.integer  "forum_subject_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["customer_id"], name: "index_forum_answers_on_customer_id", using: :btree
    t.index ["forum_subject_id"], name: "index_forum_answers_on_forum_subject_id", using: :btree
  end

  create_table "forum_categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "visual"
    t.integer  "forum_family_id"
    t.integer  "position"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["forum_family_id"], name: "index_forum_categories_on_forum_family_id", using: :btree
  end

  create_table "forum_families", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "visual"
    t.integer  "country_id"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["country_id"], name: "index_forum_families_on_country_id", using: :btree
  end

  create_table "forum_subjects", force: :cascade do |t|
    t.string   "name"
    t.text     "text"
    t.integer  "customer_id"
    t.integer  "forum_category_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "counter_cache",     default: 0
    t.index ["customer_id"], name: "index_forum_subjects_on_customer_id", using: :btree
    t.index ["forum_category_id"], name: "index_forum_subjects_on_forum_category_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

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
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
    t.index ["user_id"], name: "index_impressions_on_user_id", using: :btree
  end

  create_table "levels", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.integer  "cycle_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["cycle_id"], name: "index_levels_on_cycle_id", using: :btree
  end

  create_table "levels_products", id: false, force: :cascade do |t|
    t.integer "level_id"
    t.integer "product_id"
    t.index ["level_id"], name: "index_levels_products_on_level_id", using: :btree
    t.index ["product_id"], name: "index_levels_products_on_product_id", using: :btree
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["customer_id"], name: "index_likes_on_customer_id", using: :btree
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id", using: :btree
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "product_id"
    t.decimal  "price",                precision: 8, scale: 2, default: "0.0"
    t.decimal  "tax_rate",             precision: 8, scale: 2
    t.decimal  "tax_amount",           precision: 8, scale: 2, default: "0.0"
    t.integer  "order_id"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "processing_reference"
    t.string   "method"
    t.string   "status"
    t.decimal  "cost_price",           precision: 8, scale: 2, default: "0.0"
    t.decimal  "application_fee",      precision: 8, scale: 2, default: "0.0"
    t.index ["order_id"], name: "index_order_items_on_order_id", using: :btree
    t.index ["product_id"], name: "index_order_items_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
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
    t.decimal  "amount_paid",        precision: 8, scale: 2, default: "0.0"
    t.boolean  "exported"
    t.string   "invoice_number"
    t.index ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  end

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
    t.index ["order_id"], name: "index_payments_on_order_id", using: :btree
  end

  create_table "peers", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id", "follower_id"], name: "index_peers_on_followed_id_and_follower_id", unique: true, using: :btree
    t.index ["followed_id"], name: "index_peers_on_followed_id", using: :btree
    t.index ["follower_id"], name: "index_peers_on_follower_id", using: :btree
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "customer_id"
    t.integer  "counter_cache", default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "slug"
    t.string   "visual"
    t.string   "status"
    t.index ["customer_id"], name: "index_posts_on_customer_id", using: :btree
    t.index ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "sku"
    t.string   "permalink"
    t.string   "description"
    t.boolean  "active",                                default: true
    t.decimal  "price",         precision: 8, scale: 2, default: "0.0"
    t.boolean  "featured",                              default: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "customer_id"
    t.integer  "nb_reviews",                            default: 0
    t.decimal  "score_reviews",                         default: "0.0"
    t.string   "slug"
    t.integer  "counter_cache",                         default: 0
    t.index ["customer_id"], name: "index_products_on_customer_id", using: :btree
    t.index ["slug"], name: "index_products_on_slug", unique: true, using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.decimal  "score"
    t.integer  "product_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "customer_id"
    t.index ["customer_id"], name: "index_reviews_on_customer_id", using: :btree
    t.index ["product_id"], name: "index_reviews_on_product_id", using: :btree
  end

  create_table "stripe_accounts", force: :cascade do |t|
    t.integer "customer_id"
    t.string  "publishable_key",       limit: 255
    t.string  "secret_key",            limit: 255
    t.string  "stripe_user_id",        limit: 255
    t.string  "currency",              limit: 255
    t.string  "stripe_account_type",   limit: 255
    t.text    "stripe_account_status",             default: "{}"
    t.index ["customer_id"], name: "index_stripe_accounts_on_customer_id", using: :btree
  end

  create_table "stripe_cards", force: :cascade do |t|
    t.string   "stripe_id"
    t.string   "name"
    t.string   "brand"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.integer  "last4"
    t.string   "country"
    t.boolean  "default_source",     default: false
    t.integer  "stripe_customer_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["stripe_customer_id"], name: "index_stripe_cards_on_stripe_customer_id", using: :btree
  end

  create_table "stripe_customers", force: :cascade do |t|
    t.string   "stripe_id"
    t.integer  "account_balance"
    t.string   "currency"
    t.boolean  "delinquent",      default: false
    t.integer  "customer_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["customer_id"], name: "index_stripe_customers_on_customer_id", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.string   "slug"
    t.integer  "country_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["country_id"], name: "index_topics_on_country_id", using: :btree
  end

  create_table "updates", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_updates_on_customer_id", using: :btree
  end

  create_table "wish_lists", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "product_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["customer_id"], name: "index_wish_lists_on_customer_id", using: :btree
    t.index ["product_id"], name: "index_wish_lists_on_product_id", using: :btree
  end

  add_foreign_key "abuses", "customers"
  add_foreign_key "articles", "topics"
  add_foreign_key "attachments", "products"
  add_foreign_key "categories", "families"
  add_foreign_key "comments", "customers"
  add_foreign_key "customers", "countries"
  add_foreign_key "cycles", "countries"
  add_foreign_key "families", "countries"
  add_foreign_key "forum_answers", "customers"
  add_foreign_key "forum_answers", "forum_subjects"
  add_foreign_key "forum_categories", "forum_families"
  add_foreign_key "forum_families", "countries"
  add_foreign_key "forum_subjects", "customers"
  add_foreign_key "forum_subjects", "forum_categories"
  add_foreign_key "levels", "cycles"
  add_foreign_key "likes", "customers"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "customers"
  add_foreign_key "payments", "orders"
  add_foreign_key "posts", "customers"
  add_foreign_key "products", "customers"
  add_foreign_key "reviews", "customers"
  add_foreign_key "reviews", "products"
  add_foreign_key "stripe_accounts", "customers"
  add_foreign_key "stripe_cards", "stripe_customers"
  add_foreign_key "stripe_customers", "customers"
  add_foreign_key "topics", "countries"
  add_foreign_key "updates", "customers"
  add_foreign_key "wish_lists", "customers"
  add_foreign_key "wish_lists", "products"
end
