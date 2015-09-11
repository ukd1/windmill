class AddConfigurationGroupIdToEndpoints < ActiveRecord::Migration
  def change
    add_column :endpoints, :configuration_group_id, :integer
  end
end
