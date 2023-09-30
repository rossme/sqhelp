class CreateOrderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :order_details do |t|
      t.references :order, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :subtotal, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
