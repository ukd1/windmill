class CreateConfigurationGroups < ActiveRecord::Migration
  def self.up
    create_table :configuration_groups do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :configuration_groups
  end
end
