class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, limit: 30, null: false
      t.string :email, limit: 50, null: false
      t.string :password_digest
      t.string :phone_number, limit: 15
      t.string :department
      t.integer :role, default: 0, null: false

      t.index :username, unique: true
      t.index :email, unique: true
      t.timestamps
    end
  end
end
