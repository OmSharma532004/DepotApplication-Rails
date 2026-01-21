class AddPriceToLineItem < ActiveRecord::Migration[8.1]
  def change
    add_column :line_items, :price, :bigint
  end
end
