require 'sinatra/base'
require 'json'

require_relative '../../container'
require_relative '../../domain/carts'
require_relative '../../application/interfaces/gateways/carts'
require_relative '../../application/interfaces/auth_system'
require_relative '../../application/interfaces/gateways/products'
require_relative './view_models'


post '/api/v1/carts' do
  token = request.env["HTTP_AUTHORIZATION"]&.split&.last
  use_case = Container.create_cart_use_case

  begin
    cart = use_case.execute(token)
  rescue InvalidAuthDataError => error
    halt 401, error.message
  end

  content_type :json
  serialize_cart(cart)
end


get '/api/v1/carts/:cart_id' do
  token = request.env["HTTP_AUTHORIZATION"]&.split&.last
  cart_id = Integer(params['cart_id'])
  use_case = Container.retrieve_cart_use_case

  begin
    cart = use_case.execute(token, cart_id)
  rescue InvalidAuthDataError => error
    halt 401, error.message
  rescue ForbiddenError => error
    halt 403, error.message
  rescue CartNotFoundError => error
    halt 404, error.message
  end

  content_type :json
  serialize_cart(cart)
end
