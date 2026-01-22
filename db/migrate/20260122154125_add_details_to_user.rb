class AddDetailsToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :last_activity, :datetime
    add_column :users, :hit_count, :bigint, default: 0
  end
end
