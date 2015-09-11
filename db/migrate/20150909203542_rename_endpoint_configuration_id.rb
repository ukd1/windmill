class RenameEndpointConfigurationId < ActiveRecord::Migration
  def change
    rename_column :endpoints, :configuration_id, :assigned_config_id
  end
end
