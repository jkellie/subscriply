class AddBillingInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :billing_info, :hstore
  end
end
