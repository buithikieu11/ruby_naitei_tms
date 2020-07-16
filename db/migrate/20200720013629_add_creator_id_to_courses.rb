class AddCreatorIdToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :creator_id, :int
  end
end
