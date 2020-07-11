class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false ,unique: true
      t.text :description
      t.text :image
      t.integer :status, default: 0, null: false
      t.datetime :day_start, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :day_end

      t.timestamps
    end
  end
end
