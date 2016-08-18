class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :code
      t.string :name_abrev
      t.string :name
      t.string :id_num
      t.string :reg_addr
      t.string :contact_addr
      t.string :contact
      t.string :phone
      t.string :fax
      t.string :email
      t.string :fee
      t.integer :officer_id
      t.integer :leader_id
      t.integer :manager_id
      t.integer :status
      
      t.timestamps null: false
    end
  end
end
