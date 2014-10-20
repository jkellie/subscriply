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

ActiveRecord::Schema.define(version: 20141020171010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "locations", force: true do |t|
    t.integer "organization_id"
    t.string  "name"
    t.string  "street_address"
    t.string  "street_address_2"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
  end

  create_table "notes", force: true do |t|
    t.text     "description"
    t.integer  "user_id"
    t.integer  "organizer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.text    "subdomain"
    t.text    "name"
    t.text    "logo"
    t.text    "cover_photo"
    t.integer "account_owner_id"
    t.hstore  "settings"
  end

  create_table "organizers", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.integer  "organization_id"
    t.string   "last_name"
    t.string   "first_name"
    t.boolean  "super_admin",            default: false
    t.text     "avatar"
  end

  add_index "organizers", ["email"], name: "index_organizers_on_email", unique: true, using: :btree
  add_index "organizers", ["invitation_token"], name: "index_organizers_on_invitation_token", unique: true, using: :btree
  add_index "organizers", ["invitations_count"], name: "index_organizers_on_invitations_count", using: :btree
  add_index "organizers", ["invited_by_id"], name: "index_organizers_on_invited_by_id", using: :btree
  add_index "organizers", ["reset_password_token"], name: "index_organizers_on_reset_password_token", unique: true, using: :btree

  create_table "plans", force: true do |t|
    t.integer  "product_id"
    t.integer  "organization_id"
    t.string   "name"
    t.string   "code"
    t.string   "plan_type"
    t.text     "description"
    t.boolean  "send_renewal_reminders", default: true
    t.decimal  "amount"
    t.integer  "charge_every",           default: 1
    t.integer  "free_trial_length",      default: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "prepend_code"
    t.text     "description"
    t.text     "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.integer  "plan_id"
    t.integer  "location_id"
    t.string   "state"
    t.date     "next_bill_on"
    t.date     "next_ship_on"
    t.date     "start_date"
    t.date     "canceled_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "uuid",            default: "uuid_generate_v4()"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",                   null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.integer  "member_number"
    t.boolean  "is_sales_rep",           default: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.integer  "sales_rep_id"
    t.boolean  "contract",               default: false
    t.boolean  "w8",                     default: false
    t.boolean  "w9",                     default: false
    t.string   "street_address"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.uuid     "uuid",                   default: "uuid_generate_v4()"
    t.string   "state_code"
    t.hstore   "billing_info"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
