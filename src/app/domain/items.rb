class CartItem
  attr_accessor :id, :cart_id, :title, :qty, :price

  def initialize(id, cart_id, title, qty, price)
    @id = id
    @cart_id = cart_id
    @title = title
    @price = price
    @qty = qty
  end

  def cost
    @price * @qty
  end
end
