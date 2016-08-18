class DeleteCheckIdColumnFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :check_id
  end
end
