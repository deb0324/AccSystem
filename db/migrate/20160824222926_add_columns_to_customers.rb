class AddColumnsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :declare_type, :string
    add_column :customers, :cellphone, :string
    add_column :customers, :start_date, :date
    add_column :customers, :note_1, :text
    add_column :customers, :note_2, :text
  end
end
