class AddTaskIdColumnToChecks < ActiveRecord::Migration
  def change
    add_column :checks, :task_id, :integer
  end
end
