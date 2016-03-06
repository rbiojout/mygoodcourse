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

ActiveRecord::Schema.define(version: 20160305145337) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.integer  "priority"
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
  end

  add_index "customers", ["email"], name: "index_customers_on_email", unique: true, using: :btree
  add_index "customers", ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree

  create_table "cycles", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
  end

  add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree
  add_index "employees", ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true, using: :btree

  create_table "families", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "families", ["name"], name: "index_families_on_name", using: :btree

  create_table "levels", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.integer  "cycle_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "levels", ["cycle_id"], name: "index_levels_on_cycle_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "product_id"
    t.decimal  "price",      precision: 8, scale: 2
    t.decimal  "tax_rate",   precision: 8, scale: 2
    t.decimal  "tax_amount", precision: 8, scale: 2
    t.integer  "order_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
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
  end

  add_index "payments", ["order_id"], name: "index_payments_on_order_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "sku"
    t.string   "permalink"
    t.string   "description"
    t.string   "short_description"
    t.boolean  "active",                                    default: true
    t.decimal  "price",             precision: 8, scale: 2, default: 0.0
    t.boolean  "featured",                                  default: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.integer  "customer_id"
  end

  add_index "products", ["customer_id"], name: "index_products_on_customer_id", using: :btree

  add_foreign_key "attachments", "products"
  add_foreign_key "categories", "families"
  add_foreign_key "levels", "cycles"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "customers"
  add_foreign_key "payments", "orders"
  add_foreign_key "products", "customers"
end
