class CreateOrganizationsTable < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.text :subdomain
      t.text :name
      t.text :logo
      t.text :cover_photo
    end
    add_column :organizers, :organization_id, :integer
    add_column :organizers, :last_name, :string
    add_column :organizers, :first_name, :string
  end
end
