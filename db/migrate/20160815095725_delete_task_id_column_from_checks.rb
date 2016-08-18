class DeleteTaskIdColumnFromChecks < ActiveRecord::Migration
  def change
    remove_column :checks, :task_id
  end
end
