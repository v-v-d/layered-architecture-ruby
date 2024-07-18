require 'sinatra/base'
require 'json'

require_relative '../../container'
require_relative '../../domain/carts'
require_relative '../../application/interfaces/gateways/carts'
require_relative '../../application/interfaces/auth_system'
require_relative '../../application/interfaces/gateways/products'
require_relative './view_models'


post '/api/v1/carts/:cart_id/items' do
  token = request.env["HTTP_AUTHORIZATION"]&.split&.last
  cart_id = Integer(params['cart_id'])

  request_body = request.body.read
  data = JSON.parse(request_body, symbolize_names: true)

  product_id = Integer(data[:product_id])
  qty = Integer(data[:qty])

  use_case = Container.add_item_to_cart_use_case

  begin
    cart = use_case.execute(token, cart_id, product_id, qty)
  rescue InvalidAuthDataError => error
    halt 401, error.message
  rescue ForbiddenError => error
    halt 403, error.message
  rescue CartNotFoundError => error
    halt 404, error.message
  rescue ItemAlreadyExistsError => error
    halt 409, error.message
  rescue ProductsGatewayError => error
    halt 400, error.message
  end

  content_type :json
  serialize_cart(cart)
end
