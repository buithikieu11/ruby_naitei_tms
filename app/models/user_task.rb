class UserTask < ApplicationRecord
  belongs_to :user
  belongs_to :task

  scope :where_in, ->(column, array){where("#{column} in (?)", array)}
  scope :find_all_by_column, ->(column, value){where("#{column} = #{value}")}
end
