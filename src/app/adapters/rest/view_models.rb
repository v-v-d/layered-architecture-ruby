require 'json'

require_relative '../../domain/carts'


def serialize_cart(cart)
  {
    created_at: cart.created_at,
    id: cart.id,
    user_id: cart.user_id,
    status: cart.status,
    cost: cart.cost,
    items: cart.items.map do |item|
      {
        id: item.id,
        cart_id: item.cart_id,
        name: item.title,
        price: item.price,
        quantity: item.qty,
        cost: item.cost
      }
    end
  }.to_json
end
