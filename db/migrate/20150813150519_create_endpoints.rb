class CreateEndpoints < ActiveRecord::Migration
  def self.up
    create_table :endpoints do |t|
      t.string :node_key, null: false
      t.string :last_version
      t.integer :config_count
      t.string :last_ip
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :endpoints
  end
end
