class AddLastConfigTimeToEndpoints < ActiveRecord::Migration
  def change
    add_column :endpoints, :last_config_time, :datetime
  end
end
