class AddColumnsToEndpoints < ActiveRecord::Migration
  def change
    add_column :endpoints, :identifier, :string
    add_column :endpoints, :group_label, :string
  end
end
