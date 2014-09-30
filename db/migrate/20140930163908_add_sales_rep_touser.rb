class AddSalesRepTouser < ActiveRecord::Migration
  def change
    add_column :users, :sales_rep, :boolean, default: false
  end
end
