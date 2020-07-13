class CreateUserTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.integer :progress, default: 0, null: false
      t.text :comment

      t.index %i[user_id task_id], unique: true
      t.timestamps
    end
  end
end
