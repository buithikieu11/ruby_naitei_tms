class CreateCourseUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :course_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :role, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.index %i[user_id course_id], unique: true
      t.timestamps
    end
  end
end
