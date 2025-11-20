class LineItem < ApplicationRecord
  belongs_to :product #reference
  belongs_to :cart 

  def total_price
    product.price * quantity
  end
end
