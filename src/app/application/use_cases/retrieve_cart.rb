require_relative '../interfaces/auth_system'
require_relative '../interfaces/gateways/unit_of_work'
require_relative '../../domain/carts'


class RetrieveCartUseCase
  def initialize(uow, auth_system)
    @uow = uow
    @auth_system = auth_system
  end

  def execute(token, cart_id)
    user = @auth_system.get_user_data(token)
    cart = get_cart(cart_id)
    cart.check_ownership(user.id)

    cart
  end

  private

  def get_cart(cart_id)
    @uow.use do |uow|
      return uow.carts.retrieve(cart_id)
    end
  end
end
