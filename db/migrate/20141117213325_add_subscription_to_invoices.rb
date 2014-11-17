class AddSubscriptionToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :subscription_id, :integer
  end
end
