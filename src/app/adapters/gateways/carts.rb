require_relative '../../application/interfaces/gateways/carts'
require_relative '../../domain/carts'


class InMemoryCartsGateway < CartsGateway
  def initialize(storage)
    @storage = storage
  end

  def create(cart)
    carts = @storage.fetch(:carts, {})
    carts[cart.id] = cart
    @storage[:carts] = carts
  end

  def retrieve(cart_id)
    begin
      cart = @storage[:carts].fetch(cart_id)
    rescue KeyError => error
      raise CartNotFoundError, "Cart not found"
    end

    items = @storage.fetch(:items, {})
    cart_items = items.fetch(cart_id, {})

    Cart.new(
      cart.created_at,
      cart.id,
      cart.user_id,
      cart.status,
      cart_items.values
    )
  end
end
