require_relative '../../application/interfaces/gateways/unit_of_work'
require_relative '../../application/interfaces/gateways/carts'
require_relative '../../application/interfaces/gateways/items'


class InMemoryUnitOfWork < UnitOfWork
  def initialize(storage)
    @storage = storage
    @snapshot = storage.dup
  end

  def use
    @carts = InMemoryCartsGateway.new(@storage)
    @items = InMemoryItemsGateway.new(@storage)

    super
  end

  def commit
    @snapshot = @storage.dup
  end

  def rollback
    @storage = @snapshot
  end
end
