class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.string :name, null: false
      t.text :description
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
