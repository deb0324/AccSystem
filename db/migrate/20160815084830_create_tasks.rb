class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :customer_id
      t.integer :year
      t.string  :type
      
      t.timestamps null: false
    end
  end
end
