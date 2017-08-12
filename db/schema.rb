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

ActiveRecord::Schema.define(version: 20161222222133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "full_name",                                  null: false
    t.string   "street1",                                    null: false
    t.string   "street2"
    t.string   "city",                                       null: false
    t.string   "state",                                      null: false
    t.string   "zip",                                        null: false
    t.string   "country",    default: "US",                  null: false
    t.string   "phone"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "latitude"
    t.string   "longitude"
    t.boolean  "verified",   default: true,                  null: false
    t.string   "type",       default: "---\n:default: ''\n"
    t.integer  "user_id"
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "bro_fulfillments", force: :cascade do |t|
    t.integer  "bro_order_id"
    t.string   "guid"
    t.string   "shipment_id"
    t.string   "tracking_number"
    t.string   "line_item_ids",                array: true
    t.string   "workflow_state"
    t.text     "notes"
    t.datetime "shipped_at"
    t.datetime "delivered_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "bro_fulfillments", ["bro_order_id"], name: "index_bro_fulfillments_on_bro_order_id", using: :btree
  add_index "bro_fulfillments", ["guid"], name: "index_bro_fulfillments_on_guid", using: :btree

  create_table "bro_line_items", force: :cascade do |t|
    t.integer  "bro_variant_id"
    t.integer  "bro_order_id"
    t.integer  "position"
    t.decimal  "unit_price",     precision: 8, scale: 2
    t.string   "bro_sale_name"
    t.string   "product_name"
    t.string   "variant_name"
    t.boolean  "approved",                               default: false, null: false
    t.boolean  "shipped",                                default: false, null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "tru_bro_id"
    t.string   "color"
  end

  add_index "bro_line_items", ["bro_order_id"], name: "index_bro_line_items_on_bro_order_id", using: :btree
  add_index "bro_line_items", ["bro_variant_id"], name: "index_bro_line_items_on_bro_variant_id", using: :btree
  add_index "bro_line_items", ["position"], name: "index_bro_line_items_on_position", using: :btree

  create_table "bro_order_notes", force: :cascade do |t|
    t.integer  "bro_order_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "bro_order_notes", ["bro_order_id"], name: "index_bro_order_notes_on_bro_order_id", using: :btree
  add_index "bro_order_notes", ["user_id"], name: "index_bro_order_notes_on_user_id", using: :btree

  create_table "bro_orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "shipping_address_id"
    t.string   "email"
    t.string   "guid"
    t.string   "session_id"
    t.string   "workflow_state"
    t.string   "geekhack_username"
    t.string   "shipment_id"
    t.string   "tracking_number"
    t.string   "ip_address"
    t.string   "transaction_id"
    t.string   "paypal_email"
    t.text     "user_notes"
    t.datetime "paid_at"
    t.datetime "placed_at"
    t.decimal  "donation_amount",     precision: 8, scale: 2, default: 3.0
    t.decimal  "shipping_amount",     precision: 8, scale: 2
    t.decimal  "line_items_amount",   precision: 8, scale: 2
    t.decimal  "fee_amount",          precision: 8, scale: 2
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.integer  "bro_count",                                   default: 2
    t.datetime "submitted_at"
    t.datetime "approved_at"
  end

  add_index "bro_orders", ["guid"], name: "index_bro_orders_on_guid", using: :btree
  add_index "bro_orders", ["shipping_address_id"], name: "index_bro_orders_on_shipping_address_id", using: :btree
  add_index "bro_orders", ["user_id"], name: "index_bro_orders_on_user_id", using: :btree

  create_table "bro_product_images", force: :cascade do |t|
    t.integer  "bro_product_id"
    t.string   "file"
    t.string   "caption"
    t.integer  "position"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "thumbnail"
  end

  add_index "bro_product_images", ["bro_product_id"], name: "index_bro_product_images_on_bro_product_id", using: :btree

  create_table "bro_products", force: :cascade do |t|
    t.integer  "bro_sale_id"
    t.string   "name"
    t.text     "content"
    t.string   "image"
    t.integer  "position"
    t.string   "slug"
    t.boolean  "active",        default: true, null: false
    t.boolean  "visible",       default: true, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "thumbnail"
    t.string   "banner"
    t.text     "caption"
    t.string   "primary_color"
    t.text     "summary"
  end

  add_index "bro_products", ["bro_sale_id"], name: "index_bro_products_on_bro_sale_id", using: :btree

  create_table "bro_sale_images", force: :cascade do |t|
    t.integer  "bro_sale_id"
    t.string   "file"
    t.string   "caption"
    t.integer  "position"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "bro_sale_images", ["bro_sale_id"], name: "index_bro_sale_images_on_bro_sale_id", using: :btree

  create_table "bro_sales", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.string   "banner"
    t.string   "logo"
    t.string   "newsletter_list_id"
    t.datetime "deadline"
    t.datetime "shipping_eta"
    t.string   "meta_title"
    t.string   "slug"
    t.boolean  "active",             default: true, null: false
    t.boolean  "visible",            default: true, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "caption"
  end

  add_index "bro_sales", ["slug"], name: "index_bro_sales_on_slug", using: :btree

  create_table "bro_variants", force: :cascade do |t|
    t.integer  "bro_product_id"
    t.string   "name"
    t.integer  "position"
    t.decimal  "weight",         precision: 8, scale: 2
    t.decimal  "unit_price",     precision: 8, scale: 2
    t.boolean  "active",                                 default: true, null: false
    t.boolean  "visible",                                default: true, null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  add_index "bro_variants", ["bro_product_id"], name: "index_bro_variants_on_bro_product_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.string   "fingerprint"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["user_id"], name: "index_cards_on_user_id", using: :btree

  create_table "carousels", force: :cascade do |t|
    t.string   "title"
    t.text     "caption"
    t.integer  "position"
    t.string   "file"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "carousels", ["position"], name: "index_carousels_on_position", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "support_request_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "replied_by_email",   default: false
  end

  add_index "comments", ["support_request_id"], name: "index_comments_on_support_request_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "faq_categories", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "slug"
    t.boolean  "active",     default: true, null: false
    t.boolean  "visible",    default: true, null: false
    t.integer  "position"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "faq_categories", ["slug"], name: "index_faq_categories_on_slug", using: :btree

  create_table "faqs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "faq_category_id"
    t.string   "q"
    t.string   "caption"
    t.text     "a"
    t.datetime "published_at"
    t.string   "meta_title"
    t.string   "slug"
    t.integer  "position"
    t.boolean  "active",          default: true, null: false
    t.boolean  "visible",         default: true, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "faqs", ["faq_category_id"], name: "index_faqs_on_faq_category_id", using: :btree
  add_index "faqs", ["position"], name: "index_faqs_on_position", using: :btree
  add_index "faqs", ["slug"], name: "index_faqs_on_slug", using: :btree
  add_index "faqs", ["user_id"], name: "index_faqs_on_user_id", using: :btree

  create_table "fulfillments", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "guid"
    t.string   "shipment_id"
    t.string   "tracking_number"
    t.string   "line_item_ids",                                         array: true
    t.string   "workflow_state"
    t.text     "notes"
    t.datetime "shipped_at"
    t.datetime "delivered_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "service_name"
    t.decimal  "weight",           precision: 8, scale: 2
    t.decimal  "cost",             precision: 8, scale: 2
    t.string   "rate_id"
    t.string   "shipment_service"
  end

  add_index "fulfillments", ["guid"], name: "index_fulfillments_on_guid", using: :btree
  add_index "fulfillments", ["order_id"], name: "index_fulfillments_on_order_id", using: :btree

  create_table "group_buy_images", force: :cascade do |t|
    t.integer  "group_buy_id"
    t.string   "file"
    t.string   "caption"
    t.integer  "position"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "group_buy_images", ["group_buy_id"], name: "index_group_buy_images_on_group_buy_id", using: :btree

  create_table "group_buys", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "content"
    t.string   "image"
    t.datetime "deadline"
    t.datetime "shipping_eta"
    t.string   "meta_title"
    t.string   "slug"
    t.boolean  "active",             default: true, null: false
    t.boolean  "visible",            default: true, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "newsletter_list_id"
    t.text     "caption"
  end

  add_index "group_buys", ["slug"], name: "index_group_buys_on_slug", using: :btree
  add_index "group_buys", ["user_id"], name: "index_group_buys_on_user_id", using: :btree

  create_table "inquiries", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "guid"
    t.string   "subject"
    t.string   "name"
    t.string   "email"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "inquiries", ["guid"], name: "index_inquiries_on_guid", using: :btree
  add_index "inquiries", ["user_id"], name: "index_inquiries_on_user_id", using: :btree

  create_table "kwk_fulfillments", force: :cascade do |t|
    t.integer  "kwk_order_id"
    t.string   "guid"
    t.string   "tracking_number"
    t.string   "line_item_ids",                array: true
    t.string   "workflow_state"
    t.text     "notes"
    t.text     "customer_notes"
    t.datetime "shipped_at"
    t.datetime "delivered_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "service_name"
  end

  add_index "kwk_fulfillments", ["guid"], name: "index_kwk_fulfillments_on_guid", using: :btree
  add_index "kwk_fulfillments", ["kwk_order_id"], name: "index_kwk_fulfillments_on_kwk_order_id", using: :btree

  create_table "kwk_line_items", force: :cascade do |t|
    t.integer  "kwk_variant_id"
    t.integer  "kwk_order_id"
    t.decimal  "unit_price",     precision: 8, scale: 2
    t.string   "kwk_sale_name"
    t.string   "product_name"
    t.string   "variant_name"
    t.string   "image_url"
    t.string   "color"
    t.integer  "position"
    t.boolean  "shipped",                                default: false, null: false
    t.boolean  "approved",                               default: false, null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  add_index "kwk_line_items", ["kwk_order_id"], name: "index_kwk_line_items_on_kwk_order_id", using: :btree
  add_index "kwk_line_items", ["kwk_variant_id"], name: "index_kwk_line_items_on_kwk_variant_id", using: :btree
  add_index "kwk_line_items", ["position"], name: "index_kwk_line_items_on_position", using: :btree

  create_table "kwk_order_notes", force: :cascade do |t|
    t.integer  "kwk_order_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "kwk_order_notes", ["kwk_order_id"], name: "index_kwk_order_notes_on_kwk_order_id", using: :btree
  add_index "kwk_order_notes", ["user_id"], name: "index_kwk_order_notes_on_user_id", using: :btree

  create_table "kwk_orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "shipping_address_id"
    t.string   "email"
    t.string   "guid"
    t.string   "session_id"
    t.string   "workflow_state"
    t.string   "geekhack_username"
    t.string   "ip_address"
    t.string   "transaction_id"
    t.string   "paypal_email"
    t.text     "user_notes"
    t.integer  "kap_count",                                   default: 2
    t.datetime "paid_at"
    t.datetime "submitted_at"
    t.decimal  "donation_amount",     precision: 8, scale: 2, default: 3.0
    t.decimal  "shipping_amount",     precision: 8, scale: 2
    t.decimal  "line_items_amount",   precision: 8, scale: 2
    t.decimal  "fee_amount",          precision: 8, scale: 2
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.datetime "approved_at"
  end

  add_index "kwk_orders", ["guid"], name: "index_kwk_orders_on_guid", using: :btree
  add_index "kwk_orders", ["shipping_address_id"], name: "index_kwk_orders_on_shipping_address_id", using: :btree
  add_index "kwk_orders", ["user_id"], name: "index_kwk_orders_on_user_id", using: :btree

  create_table "kwk_products", force: :cascade do |t|
    t.integer  "kwk_sale_id"
    t.string   "name"
    t.text     "content"
    t.string   "image"
    t.string   "thumbnail"
    t.integer  "position"
    t.string   "meta_title"
    t.string   "slug"
    t.boolean  "active",      default: true, null: false
    t.boolean  "visible",     default: true, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "kwk_products", ["kwk_sale_id"], name: "index_kwk_products_on_kwk_sale_id", using: :btree

  create_table "kwk_sales", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.text     "caption"
    t.string   "banner"
    t.string   "logo"
    t.datetime "deadline"
    t.datetime "shipping_eta"
    t.string   "meta_title"
    t.string   "slug"
    t.boolean  "active",       default: true, null: false
    t.boolean  "visible",      default: true, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "kwk_sales", ["slug"], name: "index_kwk_sales_on_slug", using: :btree

  create_table "kwk_variants", force: :cascade do |t|
    t.integer  "kwk_product_id"
    t.string   "name"
    t.integer  "position"
    t.decimal  "weight",         precision: 8, scale: 2
    t.decimal  "unit_price",     precision: 8, scale: 2
    t.boolean  "active",                                 default: true, null: false
    t.boolean  "visible",                                default: true, null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  add_index "kwk_variants", ["kwk_product_id"], name: "index_kwk_variants_on_kwk_product_id", using: :btree

  create_table "line_items", force: :cascade do |t|
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "quantity",                               default: 1,     null: false
    t.decimal  "unit_price",     precision: 8, scale: 2
    t.string   "group_buy_name"
    t.string   "product_name"
    t.string   "variant_name"
    t.boolean  "shipped",                                default: false, null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.boolean  "is_flat",                                default: false
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["variant_id"], name: "index_line_items_on_variant_id", using: :btree

  create_table "microposts", force: :cascade do |t|
    t.datetime "published_at"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "group_buy_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "microposts", ["group_buy_id"], name: "index_microposts_on_group_buy_id", using: :btree
  add_index "microposts", ["user_id"], name: "index_microposts_on_user_id", using: :btree

  create_table "newsletters", force: :cascade do |t|
    t.text     "content"
    t.string   "subject"
    t.string   "slug"
    t.datetime "last_sent_at"
    t.integer  "group_buy_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "newsletters", ["group_buy_id"], name: "index_newsletters_on_group_buy_id", using: :btree
  add_index "newsletters", ["slug"], name: "index_newsletters_on_slug", using: :btree

  create_table "notes", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notes", ["order_id"], name: "index_notes_on_order_id", using: :btree
  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "shipping_address_id"
    t.string   "email"
    t.string   "guid"
    t.string   "session_id"
    t.string   "workflow_state"
    t.string   "geekhack_username"
    t.string   "shipment_service"
    t.string   "ip_address"
    t.string   "charge_id"
    t.string   "tracking_number"
    t.string   "paypal_email"
    t.text     "user_notes"
    t.text     "tracking_notes"
    t.text     "admin_notes"
    t.text     "legacy_shipping_address"
    t.datetime "paid_at"
    t.datetime "placed_at"
    t.decimal  "donation_amount",         precision: 8, scale: 2, default: 3.0
    t.decimal  "shipping_amount",         precision: 8, scale: 2
    t.decimal  "line_items_amount",       precision: 8, scale: 2
    t.decimal  "fee_amount",              precision: 8, scale: 2
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.string   "rate_id"
    t.string   "shipment_id"
    t.integer  "billing_address_id"
    t.integer  "card_id"
  end

  add_index "orders", ["billing_address_id"], name: "index_orders_on_billing_address_id", using: :btree
  add_index "orders", ["card_id"], name: "index_orders_on_card_id", using: :btree
  add_index "orders", ["charge_id"], name: "index_orders_on_charge_id", using: :btree
  add_index "orders", ["guid"], name: "index_orders_on_guid", using: :btree
  add_index "orders", ["shipping_address_id"], name: "index_orders_on_shipping_address_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "paypal_notifications", force: :cascade do |t|
    t.integer "bro_order_id"
    t.text    "params"
    t.string  "transaction_id"
    t.string  "status"
    t.integer "kwk_order_id"
  end

  add_index "paypal_notifications", ["bro_order_id"], name: "index_paypal_notifications_on_bro_order_id", using: :btree
  add_index "paypal_notifications", ["kwk_order_id"], name: "index_paypal_notifications_on_kwk_order_id", using: :btree
  add_index "paypal_notifications", ["transaction_id"], name: "index_paypal_notifications_on_transaction_id", using: :btree

  create_table "product_categories", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "slug"
    t.boolean  "active",     default: true, null: false
    t.boolean  "visible",    default: true, null: false
    t.integer  "position"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "product_categories", ["slug"], name: "index_product_categories_on_slug", using: :btree

  create_table "product_images", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "file"
    t.string   "caption"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "product_images", ["product_id"], name: "index_product_images_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "group_buy_id"
    t.string   "name"
    t.text     "content"
    t.string   "image"
    t.integer  "position"
    t.string   "meta_title"
    t.string   "slug"
    t.boolean  "active",              default: true, null: false
    t.boolean  "visible",             default: true, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "product_category_id"
  end

  add_index "products", ["group_buy_id"], name: "index_products_on_group_buy_id", using: :btree
  add_index "products", ["product_category_id"], name: "index_products_on_product_category_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "slack_invites", force: :cascade do |t|
    t.string   "email"
    t.boolean  "invited",     default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "username",                    null: false
    t.boolean  "on_reddit",   default: true,  null: false
    t.boolean  "on_geekhack", default: true,  null: false
  end

  create_table "snippets", force: :cascade do |t|
    t.string   "name"
    t.string   "scope"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "snippets", ["name"], name: "index_snippets_on_name", using: :btree
  add_index "snippets", ["scope"], name: "index_snippets_on_scope", using: :btree

  create_table "support_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.string   "subject"
    t.string   "guid"
    t.text     "content"
    t.string   "workflow_state"
    t.datetime "resolved_at"
    t.datetime "closed_at"
    t.text     "tags",           default: [],              array: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "on_hold_at"
  end

  add_index "support_requests", ["guid"], name: "index_support_requests_on_guid", using: :btree
  add_index "support_requests", ["order_id"], name: "index_support_requests_on_order_id", using: :btree
  add_index "support_requests", ["tags"], name: "index_support_requests_on_tags", using: :gin
  add_index "support_requests", ["user_id"], name: "index_support_requests_on_user_id", using: :btree

  create_table "tracking_notes", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "tracking_number"
    t.text     "notes"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "tracking_notes", ["order_id"], name: "index_tracking_notes_on_order_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.string   "guid"
    t.integer  "order_id"
    t.decimal  "amount",     precision: 8, scale: 2
    t.string   "charge_id"
    t.string   "status"
    t.string   "full_name"
    t.integer  "last_4"
    t.string   "card_brand"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["guid"], name: "index_transactions_on_guid", using: :btree
  add_index "transactions", ["order_id"], name: "index_transactions_on_order_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",                               null: false
    t.string   "geekhack_username"
    t.string   "email",                                  null: false
    t.string   "stripe_customer_id"
    t.string   "password_digest",                        null: false
    t.string   "confirmation_token"
    t.boolean  "confirmed",              default: false, null: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "admin",                  default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "avatar"
    t.boolean  "all_newsletters",        default: true
    t.string   "unsubscribe_token"
    t.text     "signature"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "variants", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "name"
    t.integer  "stock"
    t.integer  "limit"
    t.decimal  "weight",     precision: 8, scale: 2
    t.integer  "position"
    t.decimal  "unit_price", precision: 8, scale: 2
    t.decimal  "cost_price", precision: 8, scale: 2
    t.decimal  "sale_price", precision: 8, scale: 2
    t.boolean  "active",                             default: true,  null: false
    t.boolean  "visible",                            default: true,  null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "is_flat",                            default: false
  end

  add_index "variants", ["product_id"], name: "index_variants_on_product_id", using: :btree

  add_foreign_key "addresses", "users"
  add_foreign_key "bro_fulfillments", "bro_orders"
  add_foreign_key "bro_line_items", "bro_orders"
  add_foreign_key "bro_line_items", "bro_variants"
  add_foreign_key "bro_order_notes", "bro_orders"
  add_foreign_key "bro_order_notes", "users"
  add_foreign_key "bro_orders", "addresses", column: "shipping_address_id"
  add_foreign_key "bro_orders", "users"
  add_foreign_key "bro_product_images", "bro_products"
  add_foreign_key "bro_products", "bro_sales"
  add_foreign_key "bro_sale_images", "bro_sales"
  add_foreign_key "bro_variants", "bro_products"
  add_foreign_key "cards", "users"
  add_foreign_key "comments", "support_requests"
  add_foreign_key "comments", "users"
  add_foreign_key "faqs", "faq_categories"
  add_foreign_key "faqs", "users"
  add_foreign_key "fulfillments", "orders"
  add_foreign_key "group_buy_images", "group_buys"
  add_foreign_key "group_buys", "users"
  add_foreign_key "inquiries", "users"
  add_foreign_key "kwk_fulfillments", "kwk_orders"
  add_foreign_key "kwk_line_items", "kwk_orders"
  add_foreign_key "kwk_line_items", "kwk_variants"
  add_foreign_key "kwk_order_notes", "kwk_orders"
  add_foreign_key "kwk_order_notes", "users"
  add_foreign_key "kwk_orders", "addresses", column: "shipping_address_id"
  add_foreign_key "kwk_orders", "users"
  add_foreign_key "kwk_products", "kwk_sales"
  add_foreign_key "kwk_variants", "kwk_products"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "variants"
  add_foreign_key "microposts", "group_buys"
  add_foreign_key "microposts", "users"
  add_foreign_key "newsletters", "group_buys"
  add_foreign_key "notes", "orders"
  add_foreign_key "notes", "users"
  add_foreign_key "orders", "addresses", column: "billing_address_id"
  add_foreign_key "orders", "cards"
  add_foreign_key "orders", "users"
  add_foreign_key "paypal_notifications", "bro_orders"
  add_foreign_key "paypal_notifications", "kwk_orders"
  add_foreign_key "product_images", "products"
  add_foreign_key "products", "group_buys"
  add_foreign_key "products", "product_categories"
  add_foreign_key "support_requests", "orders"
  add_foreign_key "support_requests", "users"
  add_foreign_key "tracking_notes", "orders"
  add_foreign_key "transactions", "orders"
  add_foreign_key "variants", "products"
end
