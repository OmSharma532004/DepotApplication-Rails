class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product # reference
  belongs_to :cart, optional: true, counter_cache: true

  scope :recent_first, -> { order(created_at: :desc) }
  validates :product, uniqueness: { scope: :cart,
    message: "Product already added in the cart" }, if: -> { cart.present? }

  def total_price
    product.price * quantity
  end
end
