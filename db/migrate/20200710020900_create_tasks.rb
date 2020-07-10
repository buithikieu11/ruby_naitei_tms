class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.references :subject, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :step, null: false
      t.integer :status, default: 0, null: false
      t.integer :duration, null: false

      t.timestamps
    end
  end
end
