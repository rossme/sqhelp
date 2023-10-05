class CreateExercises < ActiveRecord::Migration[7.0]
  def change
    create_table :exercises do |t|
      t.string :title, default: '', null: false
      t.text :description, default: '', null: false
      t.text :query, default: '', null: false
      t.integer :difficulty
      t.string :hint, default: '', null: false
      t.jsonb :details, default: {}, null: false

      t.timestamps
    end
  end
end
