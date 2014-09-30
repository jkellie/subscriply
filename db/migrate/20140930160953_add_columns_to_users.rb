class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :organization_id, :integer
    add_column :users, :member_number, :integer
  end
end
