require 'set'

class ItemAlreadyExistsError < StandardError; end
class ForbiddenError < StandardError; end

class Cart
  attr_accessor :created_at, :id, :user_id, :status, :items

  def initialize(created_at, id, user_id, status, items)
    @created_at = created_at
    @id = id
    @user_id = user_id
    @status = status
    @items = items
  end

  def cost()
    @items.sum(&:cost)
  end

  def self.create(user_id)
    Cart.new(
      Time.now,
      generate_unique_id,
      user_id,
      "active",
      []
    )
  end

  def check_ownership(user_id)
    if @user_id != user_id
      raise ForbiddenError, "Unable to edit the cart"
    end
  end

  def add_item(item)
    check_item_existence(item)
    @items << item
  end

  private

  def self.generate_unique_id
    rand(1..1000000)  # Просто пример
  end

  def check_item_existence(item)
    item_ids = Set.new(@items.map(&:id))

    if item_ids.include?(item.id)
      raise ItemAlreadyExistsError, "Item already exists in the cart"
    end
  end
end
