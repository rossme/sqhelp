class CreateExercises < ActiveRecord::Migration[7.0]
  def change
    create_table :exercises do |t|
      t.string :title
      t.text :description
      t.text :query
      t.integer :difficulty

      t.timestamps
    end
  end
end
