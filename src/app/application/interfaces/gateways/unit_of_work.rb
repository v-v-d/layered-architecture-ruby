class UnitOfWork
  attr_accessor :carts, :items

  def use
    begin
      yield self
    rescue => e
      rollback
      raise e
    end

    commit
  end

  def commit
    raise NotImplementedError
  end

  def rollback
    raise NotImplementedError
  end
end
