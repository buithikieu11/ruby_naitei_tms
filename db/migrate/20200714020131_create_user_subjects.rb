class CreateUserSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :user_subjects do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      
      t.timestamps
    end
  end
end
