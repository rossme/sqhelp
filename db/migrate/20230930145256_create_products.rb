class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :product_name, null: false
      t.string :category
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
