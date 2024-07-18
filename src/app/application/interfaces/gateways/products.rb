class ProductsGatewayError < StandardError; end

class RetrieveProductOutputDTO
  attr_accessor :id, :title, :price

  def initialize(id, title, price)
    @id = id
    @title = title
    @price = price
  end
end

class ProductsGateway
  def retrieve(product_id)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
