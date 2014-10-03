class RenameSalesRepColumn < ActiveRecord::Migration
  def change
    rename_column :users, :sales_rep, :is_sales_rep
  end
end
