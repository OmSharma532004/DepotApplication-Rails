class LineItemPresenter
  def initialize(line_item)
    @line_item = line_item
  end

  def price
    "₹#{@line_item.product.price}"
  end
end
