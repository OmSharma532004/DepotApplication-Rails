class AddTotalPriceToOrder < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :total_price, :bigint
  end
end
