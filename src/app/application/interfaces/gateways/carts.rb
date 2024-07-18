class CartNotFoundError < StandardError; end


class CartsGateway
  def retrieve(cart_id)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
