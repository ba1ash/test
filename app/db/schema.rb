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

ActiveRecord::Schema.define(version: 20171126131953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ips", primary_key: "ip", id: :inet, force: :cascade do |t|
    t.string "authors", limit: 100, array: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", limit: 400, null: false
    t.text "content", null: false
    t.inet "ip"
    t.string "author", limit: 100, null: false
    t.float "average_rating"
    t.integer "number_of_ratings", limit: 2, default: 0, null: false
    t.index ["average_rating"], name: "posts_average_rating_desc_index_index", order: { average_rating: :desc }
  end

end
