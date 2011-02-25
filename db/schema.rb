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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110225115550) do

  create_table "peer_review_assignments", :force => true do |t|
    t.integer  "peer_review_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",          :default => false
    t.boolean  "participant",    :default => false
  end

  create_table "peer_review_feedbacks", :force => true do |t|
    t.text     "text"
    t.integer  "peer_review_assignment_id"
    t.integer  "peer_review_solution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peer_review_solutions", :force => true do |t|
    t.text     "text"
    t.integer  "peer_review_assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "feedback_returned",         :default => false
  end

  create_table "peer_reviews", :force => true do |t|
    t.string   "title"
    t.text     "task"
    t.datetime "solution_due"
    t.text     "feedback_instructions"
    t.datetime "feedback_due"
    t.string   "email"
    t.integer  "number_of_feedbacks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "started",               :default => false
    t.boolean  "reviewing",             :default => false
    t.boolean  "finished",              :default => false
  end

  create_table "solutions", :force => true do |t|
    t.text     "text"
    t.integer  "assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
