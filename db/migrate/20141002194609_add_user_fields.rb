class AddUserFields < ActiveRecord::Migration
  def change
    add_column :users, :sales_rep_id, :integer
    add_column :users, :contract, :boolean, default: false
    add_column :users, :w8, :boolean, default: false
    add_column :users, :w9, :boolean, default: false
    add_column :users, :street_address, :string
    add_column :users, :street_address_2, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :string
  end
end
