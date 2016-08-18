class AddCheckIdColumnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :check_id, :integer
  end
end
