class AddDefaultConfigIdToConfigurationGroup < ActiveRecord::Migration
  def change
    add_column :configuration_groups, :default_config_id, :integer
  end
end
