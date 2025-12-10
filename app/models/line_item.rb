class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product # reference
  belongs_to :cart, optional: true

  validates :product, uniqueness: { scope: :cart,
    message: "should happen once per cart" }, if: -> { cart.present? }

  def total_price
    product.price * quantity
  end
end
