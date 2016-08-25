class DeleteIdNameFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :id_num
  end
end
