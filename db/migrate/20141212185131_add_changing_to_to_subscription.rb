class AddChangingToToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :changing_to, :integer
  end
end
