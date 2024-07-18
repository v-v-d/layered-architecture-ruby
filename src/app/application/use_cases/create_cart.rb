require_relative '../interfaces/auth_system'
require_relative '../interfaces/gateways/unit_of_work'
require_relative '../../domain/carts'


class CreateCartUseCase
  def initialize(uow, auth_system)
    @uow = uow
    @auth_system = auth_system
  end

  def execute(token)
    user = @auth_system.get_user_data(token)
    cart = Cart.create(user.id)

    @uow.use do |uow|
      uow.carts.create(cart)
    end

    cart
  end
end
