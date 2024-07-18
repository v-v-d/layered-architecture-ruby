require 'httparty'

require_relative 'adapters/auth_system'
require_relative 'adapters/gateways/carts'
require_relative 'adapters/gateways/items'
require_relative 'adapters/gateways/products'
require_relative 'adapters/gateways/unit_of_work'
require_relative 'application/use_cases/add_item'
require_relative 'application/use_cases/create_cart'
require_relative 'application/use_cases/retrieve_cart'


class Container
  @container = {}
  @initialized = {}

  class << self
    def setup
      # resources
      @container[:storage] = -> { {carts: {}, items: {}} }
      @container[:session] = -> { HTTParty }

      # adapters
      @container[:unit_of_work] = -> { InMemoryUnitOfWork.new(get(:storage)) }
      @container[:products_gateway] = -> {
        HTTPartyProductsGateway.new(
          "https://fakestoreapi.com",
          get(:session)
        )
       }
      @container[:auth_system] = -> { FakeAuthSystem.new }

      # use cases
      @container[:add_item_to_cart_use_case] = -> {
        AddItemToCartUseCase.new(
          @container[:unit_of_work].call,
          @container[:products_gateway].call,
          @container[:auth_system].call
        )
      }
      @container[:create_cart_use_case] = -> {
        CreateCartUseCase.new(
          @container[:unit_of_work].call,
          @container[:auth_system].call
        )
      }
      @container[:retrieve_cart_use_case] = -> {
        RetrieveCartUseCase.new(
          @container[:unit_of_work].call,
          @container[:auth_system].call
        )
      }
    end

    def add_item_to_cart_use_case()
        @container[:add_item_to_cart_use_case].call
    end

    def create_cart_use_case()
        @container[:create_cart_use_case].call
    end

    def retrieve_cart_use_case()
        @container[:retrieve_cart_use_case].call
    end

    private

    def get(key)
      # Ensure the instance is only created once
      @initialized[key] ||= @container[key].call
    end
  end
end
