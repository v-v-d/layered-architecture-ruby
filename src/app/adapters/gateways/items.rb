require_relative '../../application/interfaces/gateways/items'
require_relative '../../domain/items'


class InMemoryItemsGateway < ItemsGateway
  def initialize(storage)
    @storage = storage
  end

  def retrieve(cart_id, item_id)
    begin
      return retrieve_item(cart_id, item_id)
    rescue KeyError
      raise CartItemNotFoundError, "Cart item not found"
    end
  end

  def create(item)
    items = @storage.fetch(:items, {})
    cart = items.fetch(item.cart_id, {})
    cart[item.id] = item
    items[item.cart_id] = cart
    @storage[:items] = items
  end

  private

  def retrieve_item(cart_id, item_id)
    cart = @storage[:items].fetch(cart_id)
    return cart.fetch(item_id)
  end
end
