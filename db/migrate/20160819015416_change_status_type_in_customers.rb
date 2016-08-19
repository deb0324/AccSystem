class ChangeStatusTypeInCustomers < ActiveRecord::Migration
  def change
    change_column :customers, :status, :string
  end
end
