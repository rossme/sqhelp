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

ActiveRecord::Schema[7.0].define(version: 2023_09_30_145406) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'customers', force: :cascade do |t|
    t.string 'customer_name', null: false
    t.string 'email', null: false
    t.string 'phone_number'
    t.text 'address'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'exercises', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.text 'query'
    t.integer 'difficulty'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'order_details', force: :cascade do |t|
    t.bigint 'order_id'
    t.bigint 'product_id'
    t.integer 'quantity', null: false
    t.decimal 'subtotal', precision: 10, scale: 2, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['order_id'], name: 'index_order_details_on_order_id'
    t.index ['product_id'], name: 'index_order_details_on_product_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.bigint 'customer_id'
    t.date 'order_date', null: false
    t.float 'total_amount', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['customer_id'], name: 'index_orders_on_customer_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'product_name', null: false
    t.string 'category'
    t.decimal 'price', precision: 10, scale: 2, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'order_details', 'orders'
  add_foreign_key 'order_details', 'products'
  add_foreign_key 'orders', 'customers'
end
