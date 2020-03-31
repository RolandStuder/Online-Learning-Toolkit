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

ActiveRecord::Schema.define(version: 20110301142605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "peer_review_assignments", force: :cascade do |t|
    t.integer  "peer_review_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",          default: false
    t.boolean  "participant",    default: false
  end

  create_table "peer_review_feedbacks", force: :cascade do |t|
    t.text     "text"
    t.integer  "peer_review_assignment_id"
    t.integer  "peer_review_solution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peer_review_solutions", force: :cascade do |t|
    t.text     "text"
    t.integer  "peer_review_assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "feedback_returned",         default: false
  end

  create_table "peer_reviews", force: :cascade do |t|
    t.string   "title"
    t.text     "task"
    t.datetime "solution_due"
    t.text     "feedback_instructions"
    t.datetime "feedback_due"
    t.string   "email"
    t.integer  "number_of_feedbacks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "started",               default: false
    t.boolean  "reviewing",             default: false
    t.boolean  "finished",              default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
  end

end
