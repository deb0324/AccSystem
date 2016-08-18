class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.integer :task_id
      t.string  :type
      t.boolean :flag
      
      t.timestamps null: false
    end
  end
end
