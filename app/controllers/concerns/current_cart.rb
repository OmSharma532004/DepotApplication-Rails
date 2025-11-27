module CurrentCart
private

  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end

# The set_cart method starts by getting the :cart_id from the session object and then
# attempts to find a cart corresponding to this ID. If such a cart record isn’t found
# (which will happen if the ID is nil or invalid for any reason), this method will
# proceed to create a new Cart and then store the ID of the created cart into the
# session.
