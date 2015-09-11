class AddLastConfigIdToEndpoints < ActiveRecord::Migration
  def change
    add_column :endpoints, :last_config_id, :integer
  end
end
