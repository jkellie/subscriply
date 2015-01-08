class RemoveRenewalReminders < ActiveRecord::Migration
  def change
    remove_column :plans, :send_renewal_reminders
  end
end
