class AddConfigurationIdToEndpoints < ActiveRecord::Migration
  def change
    add_column :endpoints, :configuration_id, :integer
  end
end
