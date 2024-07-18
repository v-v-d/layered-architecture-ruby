require_relative '../interfaces/auth_system'
require_relative '../interfaces/gateways/products'
require_relative '../interfaces/gateways/unit_of_work'
require_relative '../../domain/items'
require_relative '../../domain/carts'


class AddItemToCartUseCase
  def initialize(uow, products_gateway, auth_system)
    @uow = uow
    @products_gateway = products_gateway
    @auth_system = auth_system
  end

  def execute(token, cart_id, item_id, qty)
    user = @auth_system.get_user_data(token)
    cart = get_cart(cart_id)
    cart.check_ownership(user.id)
    product = @products_gateway.retrieve(item_id)

    add_item(cart, product, qty)

    cart
  end

  private

  def get_cart(cart_id)
    @uow.use do |uow|
      return uow.carts.retrieve(cart_id)
    end
  end

  def add_item(cart, product, qty)
    item = CartItem.new(product.id, cart.id, product.title, product.price, qty)
    cart.add_item(item)

    @uow.use do |uow|
      uow.items.create(item)
    end
  end
end
