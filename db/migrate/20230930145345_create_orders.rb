class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :customer, foreign_key: true
      t.date :order_date, null: false
      t.float :total_amount, null: false

      t.timestamps
    end
  end
end
