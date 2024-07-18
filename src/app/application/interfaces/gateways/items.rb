class CartItemNotFoundError < StandardError; end


class ItemsGateway
  def retrieve(cart_id, item_id)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def create(item)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
