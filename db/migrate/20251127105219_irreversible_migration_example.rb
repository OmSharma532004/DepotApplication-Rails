class IrreversibleMigrationExample < ActiveRecord::Migration[8.1]
  def up
    drop_table :example_tables
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted because it destroys data."
  end
end
