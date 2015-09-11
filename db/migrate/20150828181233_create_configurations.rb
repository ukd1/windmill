class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.string :name, null: false
      t.integer :version, null: false
      t.text :config_json, null: false
      t.text :notes
    end
  end

  def self.down
    drop_table :configurations
  end
end
