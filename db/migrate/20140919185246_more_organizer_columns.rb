class MoreOrganizerColumns < ActiveRecord::Migration
  def change
    add_column :organizations, :account_owner_id, :integer
    add_column :organizers, :super_admin, :boolean, default: false
    add_column :organizers, :avatar, :text
  end
end
