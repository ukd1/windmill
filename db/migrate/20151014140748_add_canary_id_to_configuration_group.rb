class AddCanaryIdToConfigurationGroup < ActiveRecord::Migration
  def change
    add_column :configuration_groups, :canary_config_id, :integer
  end
end
