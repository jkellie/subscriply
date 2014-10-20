class AddUuidToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :uuid, :uuid, default: "uuid_generate_v4()"
  end
end
