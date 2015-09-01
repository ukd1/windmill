class AddConfigurationGroupIdToConfigurations < ActiveRecord::Migration
  def change
    add_column :configurations, :configuration_group_id, :integer
  end
end
