class AddIndexToEndpoints < ActiveRecord::Migration
  def change
    add_index :endpoints, :node_key
  end
end
